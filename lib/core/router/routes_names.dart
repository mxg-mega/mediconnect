class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const setupFinalization = '/setup-finalization';
  static const informationCapture = '/information-capture';
  static const patient = '/patient';
  static const patientDashboard = '/patient/dashboard';
  static const patientSearch = '/patient/search';
  static const medicationSearch = '/patient/medication-search';
  static const patientActivity = '/patient/activity';
  static const patientProfile = '/patient/profile';
  static const medicationDetails = '/patient/medication-details';
  
  static const pharmacist = '/pharmacist';
  static const pharmacistDashboard = '/pharmacist/dashboard';
  static const pharmacistInventory = '/pharmacist/inventory';
  static const pharmacistInventoryItem = '/pharmacist/inventory/item';
  static const pharmacistInventoryEdit = '/pharmacist/inventory/edit';
  static const pharmacistProfile = '/pharmacist/profile';
  static const pharmacistPersonalDetails = '/pharmacist/profile/personal-details';
  static const pharmacistPharmacyInformation = '/pharmacist/profile/pharmacy-information';
  static const pharmacistPharmacyVerification = '/pharmacist/profile/pharmacy-verification';
  static const pharmacistPreferences = '/pharmacist/profile/preferences';
  static const pharmacistSecurity = '/pharmacist/profile/security';
  static const pharmacistChangePassword = '/pharmacist/profile/security/change-password';
  static const pharmacistContactInfo = '/pharmacist/profile/security/contact-info';
  static const pharmacistAddEmail = '/pharmacist/profile/security/add-email';
  static const pharmacistAddPhone = '/pharmacist/profile/security/add-phone';
  static const pharmacistSecurityVerification = '/pharmacist/profile/security/verification';
  static const pharmacistSecuritySuccess = '/pharmacist/profile/security/success';
  static const pharmacistDisplaySettings = '/pharmacist/profile/display-settings';
  static const pharmacistLanguageSettings = '/pharmacist/profile/language-settings';
  static const pharmacistNotificationSettings = '/pharmacist/profile/notification-settings';
  static const pharmacistMedicationCatalog = '/pharmacist/medication-catalog';
  static const pharmacistAddMedication = '/pharmacist/add-medication';

  static const pharmacistTermsAndPrivacy = '/pharmacist/terms-privacy';
  static const pharmacistPrivacyPolicy = '/pharmacist/terms-privacy/privacy-policy';
  static const pharmacistTermsOfService = '/pharmacist/terms-privacy/terms-of-service';

  static const dispenseHistory = '/pharmacist/dispense-history';
  static const dispenseReceipt = '/pharmacist/dispense-history/receipt';
  static const exportReceipt = '/pharmacist/dispense-history/export';
  static const codeVerification = '/code-verification';

  static const dispenseEntry = '/dispense-entry';
}