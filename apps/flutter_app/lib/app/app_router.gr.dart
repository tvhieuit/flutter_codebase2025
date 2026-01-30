// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:flutter_app/screen/splash/splash_page.dart' as _i2;
import 'package:flutter_app/screen/user/user_page.dart' as _i3;
import 'package:flutter_app/widgets/permission_dialog.dart' as _i1;

/// generated route for
/// [_i1.PermissionDialogPage]
class PermissionDialogRoute
    extends _i4.PageRouteInfo<PermissionDialogRouteArgs> {
  PermissionDialogRoute({
    _i5.Key? key,
    required String title,
    required String message,
    bool isSettingsDialog = false,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         PermissionDialogRoute.name,
         args: PermissionDialogRouteArgs(
           key: key,
           title: title,
           message: message,
           isSettingsDialog: isSettingsDialog,
         ),
         initialChildren: children,
       );

  static const String name = 'PermissionDialogRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PermissionDialogRouteArgs>();
      return _i1.PermissionDialogPage(
        key: args.key,
        title: args.title,
        message: args.message,
        isSettingsDialog: args.isSettingsDialog,
      );
    },
  );
}

class PermissionDialogRouteArgs {
  const PermissionDialogRouteArgs({
    this.key,
    required this.title,
    required this.message,
    this.isSettingsDialog = false,
  });

  final _i5.Key? key;

  final String title;

  final String message;

  final bool isSettingsDialog;

  @override
  String toString() {
    return 'PermissionDialogRouteArgs{key: $key, title: $title, message: $message, isSettingsDialog: $isSettingsDialog}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PermissionDialogRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        message == other.message &&
        isSettingsDialog == other.isSettingsDialog;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      message.hashCode ^
      isSettingsDialog.hashCode;
}

/// generated route for
/// [_i2.SplashPage]
class SplashRoute extends _i4.PageRouteInfo<void> {
  const SplashRoute({List<_i4.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i2.SplashPage());
    },
  );
}

/// generated route for
/// [_i3.UserPage]
class UserRoute extends _i4.PageRouteInfo<void> {
  const UserRoute({List<_i4.PageRouteInfo>? children})
    : super(UserRoute.name, initialChildren: children);

  static const String name = 'UserRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i3.UserPage());
    },
  );
}
