import 'package:flutter/material.dart';

import '../../widgets/home/home_action_button.dart';
import '../../core/theme/app_colors.dart';
import '../../app/routes.dart';
import '../../controllers/daily_bill_summary_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getDayName(int weekday) {
    const days = [
      "સોમવાર",
      "મંગળવાર",
      "બુધવાર",
      "ગુરુવાર",
      "શુક્રવાર",
      "શનિવાર",
      "રવિવાર",
    ];

    return days[weekday - 1];
  }

  final DailyBillSummaryController dailyBillSummaryController =
      DailyBillSummaryController();

  @override
  void initState() {
    super.initState();

    _loadTodaySummary();
  }

  Future<void> _loadTodaySummary() async {
    await dailyBillSummaryController.loadTodayTotal();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    dailyBillSummaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Prince Masala",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Prince Spices & Dryfruits", style: TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "નમસ્તે 👋",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text("આજે સ્વાગત છે.", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _getDayName(DateTime.now().weekday),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${DateTime.now().day.toString().padLeft(2, '0')}/"
                        "${DateTime.now().month.toString().padLeft(2, '0')}/"
                        "${DateTime.now().year}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              HomeActionButton(
                icon: Icons.receipt_long,
                title: "નવું બિલ",
                onTap: () async {
                  await Navigator.pushNamed(context, AppRoutes.billing);

                  // Billing screenમાંથી પાછા આવ્યા પછી
                  // today's summary ફરીથી load થશે.
                  await _loadTodaySummary();
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.pending_actions,
                title: "બાકી બિલ",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.pending);
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.inventory_2,
                title: "વસ્તુઓ",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.items);
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.people,
                title: "કર્મચારી પગાર",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.salary);
                },
              ),

              const Spacer(),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "આજનો સારાંશ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text("બિલ", style: TextStyle(fontSize: 16)),

                          Text(
                            "0",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text("રકમ", style: TextStyle(fontSize: 16)),

                          Text(
                            "₹${dailyBillSummaryController.todayTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
