import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppDialogRoute extends CustomRoute {
  AppDialogRoute({required super.page, bool barrierDismissible = true})
    : super(
        customRouteBuilder: <T>(context, child, page) => DialogRoute<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: child,
          ),
          settings: page,
        ),
      );
}

class AppBottomSheetRoute extends CustomRoute {
  AppBottomSheetRoute({
    required super.page,
    double scrollControlDisabledMaxHeightRatio = 13 / 16,
    bool useSafeArea = true,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color backgroundColor = Colors.white,
  }) : super(
         customRouteBuilder: <T>(context, child, page) => ModalBottomSheetRoute(
           builder: (context) => child,
           settings: page,
           enableDrag: enableDrag,
           isDismissible: isDismissible,
           backgroundColor: backgroundColor,
           isScrollControlled: isScrollControlled,
           useSafeArea: useSafeArea,
           scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
         ),
       );
}
