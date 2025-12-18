import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localization.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) =>
          previous.isInitialized != current.isInitialized,
      listener: (context, state) {
        if (state.isInitialized) {
          // Navigate to home or login page
          // Navigator.pushReplacement(...);
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).splash_screen_title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.isLoading) ...[
                    SizedBox(height: 16.h),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

