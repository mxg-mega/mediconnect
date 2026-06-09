import * as admin from "firebase-admin";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";
import * as crypto from "crypto";

admin.initializeApp();

setGlobalOptions({maxInstances: 10});

/**
 * Helper to generate a random 6-digit OTP
 */
function generateRandomOTP(): string {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

/**
 * generateOTP
 * Generates an OTP, saves it to the user's document, and writes to the `mail` collection.
 * Supports `intent`: 'signup' or 'password_reset'.
 */
export const generateOTP = onCall(async (request) => {
  const email = request.data.email;
  const intent = request.data.intent || "signup";

  if (!email) {
    throw new HttpsError("invalid-argument", "Email address is required.");
  }

  let uid = request.auth?.uid;

  // Resolve UID if not provided by auth state (e.g. password reset)
  if (!uid) {
    if (intent === "password_reset") {
      try {
        const userRecord = await admin.auth().getUserByEmail(email);
        uid = userRecord.uid;
      } catch (error) {
        // Silently succeed to prevent email enumeration attacks
        return {success: true, message: "If the email is registered, an OTP will be sent."};
      }
    } else {
      throw new HttpsError("unauthenticated", "User must be logged in for this action.");
    }
  }

  const otp = generateRandomOTP();
  const db = admin.firestore();

  try {
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 10);

    await db.collection("users").doc(uid).collection("otp_codes").doc("current").set({
      code: otp,
      intent: intent,
      expiresAt: admin.firestore.Timestamp.fromDate(expiresAt),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await db.collection("mail").add({
      to: email,
      message: {
        subject: intent === "password_reset" ? "Reset Your Password - Medconnect" : "Your Verification Code - Mediconnect",
        text: `Your code is: ${otp}. It will expire in 10 minutes.`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;">
            <h2 style="color: #2c3e50; text-align: center;">Medconnect</h2>
            <p style="color: #555; font-size: 16px;">Hello,</p>
            <p style="color: #555; font-size: 16px;">Your code is:</p>
            <div style="text-align: center; margin: 30px 0;">
              <span style="font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #3498db; background-color: #f0f8ff; padding: 10px 20px; border-radius: 8px;">
                ${otp}
              </span>
            </div>
            <p style="color: #555; font-size: 16px;">This code will expire in 10 minutes. If you did not request this, please ignore this email.</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;" />
            <p style="color: #999; font-size: 12px; text-align: center;">© 2026 Mediconnect</p>
          </div>
        `,
      },
    });

    return {success: true, message: "OTP sent successfully."};
  } catch (error) {
    console.error("Error generating OTP:", error);
    throw new HttpsError("internal", "Failed to generate OTP.");
  }
});

/**
 * verifyOTP
 * Verifies the OTP. If intent is password_reset, returns a resetToken.
 */
export const verifyOTP = onCall(async (request) => {
  const {code, email, intent = "signup"} = request.data;

  if (!code || !email) {
    throw new HttpsError("invalid-argument", "OTP code and email are required.");
  }

  let uid = request.auth?.uid;

  if (!uid) {
    if (intent === "password_reset") {
      try {
        const userRecord = await admin.auth().getUserByEmail(email);
        uid = userRecord.uid;
      } catch (error) {
        throw new HttpsError("not-found", "User not found.");
      }
    } else {
      throw new HttpsError("unauthenticated", "User must be logged in.");
    }
  }

  const db = admin.firestore();
  const otpRef = db.collection("users").doc(uid).collection("otp_codes").doc("current");

  try {
    const doc = await otpRef.get();

    if (!doc.exists) {
      throw new HttpsError("not-found", "No OTP found for this user.");
    }

    const data = doc.data();
    if (!data || data.code !== code) {
      throw new HttpsError("invalid-argument", "Invalid OTP code.");
    }

    if (data.expiresAt.toDate() < new Date()) {
      throw new HttpsError("failed-precondition", "OTP has expired.");
    }

    if (data.intent !== intent) {
      throw new HttpsError("invalid-argument", "OTP intent mismatch.");
    }

    await otpRef.delete();

    if (intent === "signup") {
      await db.collection("users").doc(uid).update({
        verification_status: "verified",
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      });
      return {success: true, message: "OTP verified successfully."};
    }

    if (intent === "password_reset") {
      const resetToken = crypto.randomBytes(32).toString("hex");
      const tokenExpiresAt = new Date();
      tokenExpiresAt.setMinutes(tokenExpiresAt.getMinutes() + 15);

      await db.collection("users").doc(uid).collection("password_reset_tokens").doc("current").set({
        token: resetToken,
        expiresAt: admin.firestore.Timestamp.fromDate(tokenExpiresAt),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return {success: true, resetToken: resetToken};
    }

    throw new HttpsError("internal", "Unknown intent.");
  } catch (error) {
    console.error("Error verifying OTP:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to verify OTP.");
  }
});

/**
 * resetPassword
 * Uses the resetToken to update the user's password securely.
 */
export const resetPassword = onCall(async (request) => {
  const {email, resetToken, newPassword} = request.data;

  if (!email || !resetToken || !newPassword) {
    throw new HttpsError("invalid-argument", "Email, resetToken, and newPassword are required.");
  }

  try {
    const userRecord = await admin.auth().getUserByEmail(email);
    const uid = userRecord.uid;

    const db = admin.firestore();
    const tokenRef = db.collection("users").doc(uid).collection("password_reset_tokens").doc("current");
    const doc = await tokenRef.get();

    if (!doc.exists) {
      throw new HttpsError("permission-denied", "Invalid or expired reset token.");
    }

    const data = doc.data();
    if (!data || data.token !== resetToken) {
      throw new HttpsError("permission-denied", "Invalid reset token.");
    }

    if (data.expiresAt.toDate() < new Date()) {
      throw new HttpsError("permission-denied", "Reset token has expired.");
    }

    // Token is valid! Update password
    await admin.auth().updateUser(uid, {password: newPassword});

    // Invalidate token
    await tokenRef.delete();

    return {success: true, message: "Password updated successfully."};
  } catch (error) {
    console.error("Error resetting password:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to reset password.");
  }
});
