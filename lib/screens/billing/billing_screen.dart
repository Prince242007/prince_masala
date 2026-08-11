import 'package:flutter/material.dart';

import '../../controllers/billing_controller.dart';
import '../../widgets/billing/billing_input_section.dart';
import '../../widgets/billing/bill_item_card.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final BillingController billingController = BillingController();

  @override
  void dispose() {
    billingController.dispose();
    super.dispose();
  }

  void deleteItem(int index) {
    billingController.removeItem(index);
  }

  void editItem(int index) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Edit feature આપણે આગળ બનાવશું.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('બિલિંગ'),
      ),
      body: AnimatedBuilder(
        animation: billingController,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom,
                  ),
                  child: Column(
                    children: [
                      BillingInputSection(
                        onAddItem: billingController.addItem,
                      ),

                      const Divider(
                        height: 1,
                      ),

                      if (billingController.items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 40,
                          ),
                          child: Text(
                            'હજુ કોઈ વસ્તુ ઉમેરાઈ નથી.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              billingController.items.length,
                          itemBuilder: (context, index) {
                            final item =
                                billingController.items[index];

                            return BillItemCard(
                              itemNumber: index + 1,
                              item: item,
                              onEdit: () {
                                editItem(index);
                              },
                              onDelete: () {
                                deleteItem(index);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'કુલ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${billingController.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}