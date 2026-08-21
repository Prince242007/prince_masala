import 'package:flutter/material.dart';

import '../../models/bill_item.dart';
import '../../controllers/billing_controller.dart';
import '../../widgets/billing/billing_input_section.dart';
import '../../widgets/billing/bill_item_card.dart';
import '../../widgets/billing/edit_bill_item_dialog.dart';
import '../../services/print_service.dart';

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

  Future<void> editItem(int index) async {
    final item = billingController.items[index];

    final BillItem? updatedItem = await showDialog<BillItem>(
      context: context,
      builder: (context) {
        return EditBillItemDialog(item: item);
      },
    );

    if (updatedItem != null) {
      billingController.updateItem(index, updatedItem);
    }
  }

  Future<void> printBill() async {
    if (billingController.items.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('પહેલા બિલમાં વસ્તુ ઉમેરો.')),
        );
      return;
    }

    await PrintService.printBill(
      customerName: 'Customer',
      items: billingController.items,
      total: billingController.total,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('બિલિંગ')),
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
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      BillingInputSection(onAddItem: billingController.addItem),

                      const Divider(height: 1),

                      if (billingController.items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'હજુ કોઈ વસ્તુ ઉમેરાઈ નથી.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: billingController.items.length,
                          itemBuilder: (context, index) {
                            final item = billingController.items[index];

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
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, offset: Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: printBill,
                        icon: const Icon(Icons.print),
                        label: const Text(
                          'બિલ પ્રિન્ટ કરો',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
