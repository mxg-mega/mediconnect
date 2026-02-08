class TermsAndConditionsTextModel {
  final String title;
  final List<String> description;

  TermsAndConditionsTextModel({required this.title, required this.description});
}

final List<TermsAndConditionsTextModel> termsAndConditionsText = [
  TermsAndConditionsTextModel(
    title: 'Terms of Service',
    description: [
      'Welcome to our medication management app. By using our services, you agree to these terms. Please read them carefully.',
      '1. Service Description: Our app helps pharmacists manage medication orders, communicate with patients, and track inventory.',
      '2. User Responsibilities: You are responsible for maintaining the confidentiality of your account and for all activities under your account.',
      '3. Data Privacy: We collect and use your data as described in our Privacy Policy. Your data is protected with industry-standard security measures.',
      '4. Intellectual Property: All content and software in the app are owned by us or our licensors and are protected by copyright and other intellectual property laws.',
      '5. Limitation of Liability: We are not liable for any indirect, incidental, or consequential damages arising from your use of the app.',
      '6. Changes to Terms: We may update these terms from time to time. We will notify you of any significant changes.',
      '7. Governing Law: These terms are governed by the laws of the jurisdiction in which our company is registered.',
    ],
  ),
  TermsAndConditionsTextModel(
    title: 'Privacy Policy',
    description: [
      'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.',
      '1. Information We Collect: We collect information you provide, such as your name, contact details, and professional credentials.',
      '2. How We Use Your Information: We use your information to provide and improve our services, communicate with you, and ensure security.',
      '3. Data Sharing: We do not sell your personal information. We may share data with service providers who assist us in operating the app.',
      '4. Data Security: We use encryption and other security measures to protect your data from unauthorized access.',
      '5. Your Rights: You have the right to access, correct, or delete your personal information. Contact us to exercise these rights.',
      '6. Policy Updates: We may update this policy. We will notify you of any significant changes.',
    ],
  ),
];
