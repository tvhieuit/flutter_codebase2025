import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/di.dart';
import '../screen/splash/splash_bloc.dart';
import '../screen/splash/splash_event.dart';
import '../screen/splash/splash_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashBloc>()..add(const SplashEventStart()),
      child: const SplashRoute(),
    );
  }
}

