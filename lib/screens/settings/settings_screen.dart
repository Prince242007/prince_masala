import 'package:flutter/material.dart';

import 'item_management_screen.dart';
import 'monthly_business_summary_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('સેટિંગ્સ'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // Item Management
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.inventory_2_outlined,
              ),

              title: const Text(
                'વસ્તુ વ્યવસ્થાપન',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: const Text(
                'વસ્તુ ઉમેરો, સુધારો અથવા કાઢી નાખો',
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const ItemManagementScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Monthly Business Summary
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.bar_chart_outlined,
              ),

              title: const Text(
                'માસિક વેપાર સારાંશ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: const Text(
                'મહિના પ્રમાણે બિલ અને વેચાણ જુઓ',
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const MonthlyBusinessSummaryScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}