// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '드라이버 앱';

  @override
  String get homeTitle => '대시보드';

  @override
  String get welcomeMessage => '환영합니다, 드라이버!';

  @override
  String get homeDescription => '배송을 받을 준비가 되었습니다';

  @override
  String get goOnline => '온라인으로 전환';

  @override
  String get goOffline => '오프라인으로 전환';

  @override
  String get currentDeliveries => '진행 중인 배송';

  @override
  String get noDeliveries => '현재 배송이 없습니다';

  @override
  String get earnings => '수익';

  @override
  String get todayEarnings => '오늘의 수익';

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
