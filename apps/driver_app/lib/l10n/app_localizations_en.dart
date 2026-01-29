// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Driver App';

  @override
  String get homeTitle => 'Dashboard';

  @override
  String get welcomeMessage => 'Welcome, Driver!';

  @override
  String get homeDescription => 'You are ready to accept deliveries';

  @override
  String get goOnline => 'Go Online';

  @override
  String get goOffline => 'Go Offline';

  @override
  String get currentDeliveries => 'Current Deliveries';

  @override
  String get noDeliveries => 'No deliveries at the moment';

  @override
  String get earnings => 'Earnings';

  @override
  String get todayEarnings => 'Today\'s Earnings';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';
}
