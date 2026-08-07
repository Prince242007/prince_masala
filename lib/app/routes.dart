import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/billing/billing_screen.dart';
import '../screens/items/items_screen.dart';
import '../screens/pending/pending_screen.dart';
import '../screens/salary/salary_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String home = '/';
  static const String billing = '/billing';
  static const String items = '/items';
  static const String pending = '/pending';
  static const String salary = '/salary';
  static const String settings = '/settings';

  // Route Map
  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomeScreen(),
        billing: (_) => const BillingScreen(),
        items: (_) => const ItemsScreen(),
        pending: (_) => const PendingScreen(),
        salary: (_) => const SalaryScreen(),
        settings: (_) => const SettingsScreen(),
      };
}