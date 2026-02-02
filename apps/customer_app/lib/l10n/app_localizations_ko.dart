// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '고객 앱';

  @override
  String get homeTitle => '홈';

  @override
  String get welcomeMessage => '환영합니다!';

  @override
  String get homeDescription => '고객 앱에 로그인되었습니다';

  @override
  String get logout => '로그아웃';

  @override
  String get settings => '설정';

  @override
  String get profile => '프로필';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get themeModeTitle => '테마';

  @override
  String get themeModeSystem => '시스템';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeDark => '다크';

  @override
  String get languageTitle => '언어';

  @override
  String get languageSystem => '시스템';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageKorean => '한국어';
}
