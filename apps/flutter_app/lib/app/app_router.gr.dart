// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:flutter_app/screen/splash/splash_page.dart' as _i2;
import 'package:flutter_app/screen/user/user_bloc.dart' as _i9;
import 'package:flutter_app/screen/user/user_delete_confirmation_page.dart'
    as _i3;
import 'package:flutter_app/screen/user/user_details_page.dart' as _i4;
import 'package:flutter_app/screen/user/user_page.dart' as _i5;
import 'package:flutter_app/screen/user/user_update_page.dart' as _i6;
import 'package:flutter_app/widgets/permission_dialog.dart' as _i1;

/// generated route for
/// [_i1.PermissionDialogPage]
class PermissionDialogRoute
    extends _i7.PageRouteInfo<PermissionDialogRouteArgs> {
  PermissionDialogRoute({
    _i8.Key? key,
    required String title,
    required String message,
    bool isSettingsDialog = false,
    List<_i7.PageRouteInfo>? children,
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

  static _i7.PageInfo page = _i7.PageInfo(
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

  final _i8.Key? key;

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
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i7.WrappedRoute(child: const _i2.SplashPage());
    },
  );
}

/// generated route for
/// [_i3.UserDeleteConfirmationPage]
class UserDeleteConfirmationRoute extends _i7.PageRouteInfo<void> {
  const UserDeleteConfirmationRoute({List<_i7.PageRouteInfo>? children})
    : super(UserDeleteConfirmationRoute.name, initialChildren: children);

  static const String name = 'UserDeleteConfirmationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.UserDeleteConfirmationPage();
    },
  );
}

/// generated route for
/// [_i4.UserDetailsPage]
class UserDetailsRoute extends _i7.PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({
    _i8.Key? key,
    required dynamic user,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         UserDetailsRoute.name,
         args: UserDetailsRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'UserDetailsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserDetailsRouteArgs>();
      return _i4.UserDetailsPage(key: args.key, user: args.user);
    },
  );
}

class UserDetailsRouteArgs {
  const UserDetailsRouteArgs({this.key, required this.user});

  final _i8.Key? key;

  final dynamic user;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserDetailsRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i5.UserPage]
class UserRoute extends _i7.PageRouteInfo<void> {
  const UserRoute({List<_i7.PageRouteInfo>? children})
    : super(UserRoute.name, initialChildren: children);

  static const String name = 'UserRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i7.WrappedRoute(child: const _i5.UserPage());
    },
  );
}

/// generated route for
/// [_i6.UserUpdatePage]
class UserUpdateRoute extends _i7.PageRouteInfo<UserUpdateRouteArgs> {
  UserUpdateRoute({
    _i8.Key? key,
    required int userId,
    required _i9.UserBloc userBloc,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         UserUpdateRoute.name,
         args: UserUpdateRouteArgs(
           key: key,
           userId: userId,
           userBloc: userBloc,
         ),
         initialChildren: children,
       );

  static const String name = 'UserUpdateRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserUpdateRouteArgs>();
      return _i6.UserUpdatePage(
        key: args.key,
        userId: args.userId,
        userBloc: args.userBloc,
      );
    },
  );
}

class UserUpdateRouteArgs {
  const UserUpdateRouteArgs({
    this.key,
    required this.userId,
    required this.userBloc,
  });

  final _i8.Key? key;

  final int userId;

  final _i9.UserBloc userBloc;

  @override
  String toString() {
    return 'UserUpdateRouteArgs{key: $key, userId: $userId, userBloc: $userBloc}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserUpdateRouteArgs) return false;
    return key == other.key &&
        userId == other.userId &&
        userBloc == other.userBloc;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode ^ userBloc.hashCode;
}
