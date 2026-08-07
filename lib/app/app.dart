import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'routes.dart';

class PrinceMasalaApp extends StatelessWidget {
  const PrinceMasalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Prince Masala',

      theme: AppTheme.lightTheme,

      initialRoute: AppRoutes.home,

      routes: AppRoutes.routes,
    );
  }
}