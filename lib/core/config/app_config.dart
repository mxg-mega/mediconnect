class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.mediconnect.com';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // API Endpoints
  static const String authLogin = '/auth/login';
  static const String authSignup = '/auth/signup';
  static const String authSignout = '/auth/signout';
  static const String authCurrentUser = '/auth/current-user';
  static const String pharmacyInfo = '/pharmacy/info';
  static const String pharmacyEmployees = '/pharmacy/employees';

  // Firebase Configuration
  static const String firebaseApiKey = 'your-api-key';
  static const String firebaseAuthDomain = 'your-project.firebaseapp.com';
  static const String firebaseProjectId = 'your-project-id';
  static const String firebaseStorageBucket = 'your-project.appspot.com';
  static const String firebaseMessagingSenderId = '123456789';
  static const String firebaseAppId = '1:123456789:web:abcdef123456';

  // User Types
  static const String userTypePatient = 'patient';
  static const String userTypePharmacist = 'pharmacist';

  // App Constants
  static const String appName = 'MediConnect';
  static const String appVersion = '1.0.0';
  static const int maxLoginAttempts = 5;
  static const Duration sessionTimeout = Duration(hours: 24);

  // UI Constants
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 56.0;


  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const Duration cacheTimeout = Duration(minutes: 30);
  static const String cacheKeyPrefix = 'mediconnect_';

  // Notification Settings
  static const String notificationChannelId = 'mediconnect_channel';
  static const String notificationChannelName = 'MediConnect Notifications';
  static const String notificationChannelDescription = 'App notifications for MediConnect';
}
