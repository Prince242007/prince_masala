import 'package:flutter/material.dart';

import '../../widgets/home/home_action_button.dart';
import '../../core/theme/app_colors.dart';
import '../../app/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Prince Masala",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Prince Spices & Dryfruits",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.settings,
              );
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

              const Text(
                "નમસ્તે 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "આજે સ્વાગત છે.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              HomeActionButton(
                icon: Icons.receipt_long,
                title: "નવું બિલ",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.billing,
                  );
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.pending_actions,
                title: "બાકી બિલ",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pending,
                  );
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.inventory_2,
                title: "વસ્તુઓ",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.items,
                  );
                },
              ),

              const SizedBox(height: 15),

              HomeActionButton(
                icon: Icons.people,
                title: "કર્મચારી પગાર",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.salary,
                  );
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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: const [

                          Text(
                            "બિલ",
                            style: TextStyle(fontSize: 16),
                          ),

                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: const [

                          Text(
                            "રકમ",
                            style: TextStyle(fontSize: 16),
                          ),

                          Text(
                            "₹0",
                            style: TextStyle(
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