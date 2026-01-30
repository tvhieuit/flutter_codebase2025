import 'package:flutter/material.dart';

import 'app/app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  configureDependencies();

  runApp(MyApp());
}
