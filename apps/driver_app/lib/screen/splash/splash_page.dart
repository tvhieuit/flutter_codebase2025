import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_router.dart';
import '../../app/auth_routes.dart';
import 'splash_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget implements AutoRouteWrapper {
  const SplashPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<SplashBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _SplashView();
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) =>
          previous.authStatus != current.authStatus,
      listener: (context, state) {
        final router = context.router;

        switch (state.authStatus) {
          case AuthStatus.authenticated:
            router.replaceAll([const HomeRoute()]);
          case AuthStatus.unauthenticated:
            router.replaceAll([const LoginRoute()]);
          case AuthStatus.unknown:
            // Still checking, do nothing
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade700,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'Driver App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Deliver with confidence',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
