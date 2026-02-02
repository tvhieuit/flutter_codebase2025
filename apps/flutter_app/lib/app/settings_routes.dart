import 'package:feature_app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for AppSettingsPage from feature_app_settings package
class AppSettingsRoute extends PageRouteInfo<void> {
  const AppSettingsRoute({
    List<PageRouteInfo>? children,
  }) : super(
         AppSettingsRoute.name,
         initialChildren: children,
       );

  static const String name = 'AppSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppSettingsPage();
    },
  );
}
