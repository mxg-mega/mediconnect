import * as admin from "firebase-admin";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";

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
 * Generates an OTP, saves it to the user's document, and writes to the `mail` collection
 * to trigger the Firestore Email Extension.
 */
export const generateOTP = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError(
      "unauthenticated",
      "User must be logged in to request an OTP."
    );
  }

  const email = request.data.email;
  if (!email) {
    throw new HttpsError("invalid-argument", "Email address is required.");
  }

  const otp = generateRandomOTP();
  const db = admin.firestore();

  try {
    // 1. Save the OTP to the user's document (valid for 10 minutes)
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 10);

    await db.collection("users").doc(uid).collection("otp_codes").doc("current").set({
      code: otp,
      expiresAt: admin.firestore.Timestamp.fromDate(expiresAt),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // 2. Write to the `mail` collection to trigger the Email Extension
    await db.collection("mail").add({
      to: email,
      message: {
        subject: "Your Verification Code - Mediconnect",
        text: `Your verification code is: ${otp}. It will expire in 10 minutes.`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;">
            <h2 style="color: #2c3e50; text-align: center;">Mediconnect Verification</h2>
            <p style="color: #555; font-size: 16px;">Hello,</p>
            <p style="color: #555; font-size: 16px;">Your verification code is:</p>
            <div style="text-align: center; margin: 30px 0;">
              <span style="font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #3498db; background-color: #f0f8ff; padding: 10px 20px; border-radius: 8px;">
                ${otp}
              </span>
            </div>
            <p style="color: #555; font-size: 16px;">This code will expire in 10 minutes. If you did not request this code, please ignore this email.</p>
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
 * Checks if the provided OTP matches the one saved for the user and hasn't expired.
 */
export const verifyOTP = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError(
      "unauthenticated",
      "User must be logged in to verify an OTP."
    );
  }

  const {code} = request.data;
  if (!code) {
    throw new HttpsError("invalid-argument", "OTP code is required.");
  }

  const db = admin.firestore();
  const otpRef = db.collection("users").doc(uid).collection("otp_codes").doc("current");

  try {
    const doc = await otpRef.get();

    if (!doc.exists) {
      throw new HttpsError("not-found", "No OTP found for this user.");
    }

    const data = doc.data();
    if (!data) {
      throw new HttpsError("internal", "Invalid OTP data.");
    }

    const {code: savedCode, expiresAt} = data;

    // Check expiration
    if (expiresAt.toDate() < new Date()) {
      throw new HttpsError("failed-precondition", "OTP has expired.");
    }

    // Check code match
    if (savedCode !== code) {
      throw new HttpsError("invalid-argument", "Invalid OTP code.");
    }

    // Validation successful!
    // 1. Update user profile verification status
    await db.collection("users").doc(uid).update({
      verification_status: "verified",
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // 2. Delete the OTP document so it can't be reused
    await otpRef.delete();

    return {success: true, message: "OTP verified successfully."};
  } catch (error) {
    console.error("Error verifying OTP:", error);
    if (error instanceof HttpsError) {
      throw error;
    }
    throw new HttpsError("internal", "Failed to verify OTP.");
  }
});
