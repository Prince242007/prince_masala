import 'package:flutter/material.dart';

import '../../models/bill_item.dart';
import '../../controllers/billing_controller.dart';
import '../../widgets/billing/billing_input_section.dart';
import '../../widgets/billing/bill_item_card.dart';
import '../../widgets/billing/edit_bill_item_dialog.dart';
import '../../services/billing_print_service.dart';
import '../../controllers/daily_bill_summary_controller.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final BillingController billingController = BillingController();
  final DailyBillSummaryController dailyBillSummaryController =
      DailyBillSummaryController();
  String customerName = '';
  @override
  void initState() {
    super.initState();

    dailyBillSummaryController.loadTodayTotal();
  }

  @override
  void dispose() {
    billingController.dispose();
    dailyBillSummaryController.dispose();
    super.dispose();
  }

  bool get hasBillData {
    return billingController.items.isNotEmpty || customerName.trim().isNotEmpty;
  }

  Future<bool> showCancelBillDialog() async {
    if (!hasBillData) {
      return true;
    }

    final shouldCancel = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('બિલ રદ કરવું છે?'),
          content: const Text(
            'તમે ખરેખર આ બિલ રદ કરવા માંગો છો?\n\n'
            'ઉમેરેલી વસ્તુઓ અને બિલની માહિતી દૂર થઈ જશે.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('ના, ચાલુ રાખો'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('હા, બિલ રદ કરો'),
            ),
          ],
        );
      },
    );

    return shouldCancel ?? false;
  }

  Future<void> handleBack() async {
    final shouldCancel = await showCancelBillDialog();

    if (!shouldCancel || !mounted) {
      return;
    }

    billingController.clearBill();
    customerName = '';

    Navigator.of(context).pop();
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

    try {
      await BillingPrintService.printBill(
        customerName: customerName,
        items: billingController.items,
        total: billingController.total,
      );

      await dailyBillSummaryController.addPrintedBill(billingController.total);
    } catch (e) {
      debugPrint('PRINT BILL ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('બિલ પ્રિન્ટ કરવામાં ભૂલ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        await handleBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('બિલિંગ'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleBack,
          ),
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
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        BillingInputSection(
                          onAddItem: (item, enteredCustomerName) {
                            customerName = enteredCustomerName;

                            billingController.addItem(item);
                          },
                        ),

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
      ),
    );
  }
}
