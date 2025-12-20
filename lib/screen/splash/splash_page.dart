import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../extensions/l10n_extension.dart';
import 'splash_bloc.dart';

@RoutePage()
class SplashPage extends StatelessWidget implements AutoRouteWrapper {
  const SplashPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) => previous.isInitialized != current.isInitialized && current.isInitialized,
      listener: (context, state) {
        // Navigate based on authentication status
        // For now, we'll just show the result
        // Later you can navigate to home or login
        // context.router.replace(const HomeRoute());
      },
      child: Scaffold(
        body: BlocBuilder<SplashBloc, SplashState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading || previous.error != current.error,
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    const Icon(
                      Icons.flutter_dash,
                      size: 120,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),

                    // App Name
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading Indicator
                    if (state.isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),

                    // Error Message
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
