import 'package:feature_app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for AppSettingsPage from feature_app_settings package
class AppSettingsRoute extends PageRouteInfo<AppSettingsRouteArgs> {
  AppSettingsRoute({
    required AppSettingsSheetStrings strings,
    List<PageRouteInfo>? children,
  }) : super(
         AppSettingsRoute.name,
         args: AppSettingsRouteArgs(strings: strings),
         initialChildren: children,
       );

  static const String name = 'AppSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppSettingsRouteArgs>();
      return AppSettingsPage(strings: args.strings);
    },
  );
}

class AppSettingsRouteArgs {
  final AppSettingsSheetStrings strings;

  const AppSettingsRouteArgs({required this.strings});
}
