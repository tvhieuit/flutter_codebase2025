import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localization.dart';

class AppErrorWidget extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            error ?? S.of(context).error,
            style: TextStyle(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(S.of(context).retry),
            ),
          ],
        ],
      ),
    );
  }
}

