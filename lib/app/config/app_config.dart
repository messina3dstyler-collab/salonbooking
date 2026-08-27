/// Configurazione globale dell'app.
///
/// Tutte le informazioni che possono essere riutilizzate
/// in più parti del progetto vengono centralizzate qui.
class AppConfig {
  AppConfig._();

  //==================================================
  // APP INFO
  //==================================================

  static const String appName = 'SalonBooking';

  static const String appVersion = '0.1.0';

  static const String companyName = 'SalonBooking';

  //==================================================
  // ENVIRONMENT
  //==================================================

  static const bool isProduction = false;

  static const bool enableLogs = true;

  //==================================================
  // ANIMATIONS
  //==================================================

  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);

  static const Duration splashDuration = Duration(seconds: 2);

  //==================================================
  // BOOKING
  //==================================================

  static const int bookingIntervalMinutes = 30;

  static const int maxBookingDays = 90;

  //==================================================
  // FIREBASE
  //==================================================

  static const String usersCollection = 'users';

  static const String salonsCollection = 'salons';

  static const String bookingsCollection = 'bookings';

  static const String servicesCollection = 'services';

  static const String staffCollection = 'staff';

  //==================================================
  // STORAGE
  //==================================================

  static const String themeKey = 'theme_mode';

  static const String onboardingKey = 'onboarding_completed';

  static const String languageKey = 'language';

  static const String rememberMeKey = 'remember_me';

  //==================================================
  // SUPPORT
  //==================================================

  static const String supportEmail = 'support@salonbooking.app';

  static const String website = 'https://salonbooking.app';

  //==================================================
  // DATE FORMAT
  //==================================================

  static const String defaultDateFormat = 'dd/MM/yyyy';

  static const String defaultTimeFormat = 'HH:mm';
}
