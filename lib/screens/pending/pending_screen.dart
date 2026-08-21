import 'package:flutter/material.dart';

import '../../controllers/pending_bill_controller.dart';
import '../../models/pending_bill.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final PendingBillController pendingBillController =
      PendingBillController();

  @override
  void initState() {
    super.initState();

    pendingBillController.loadBills();
  }

  @override
  void dispose() {
    pendingBillController.dispose();
    super.dispose();
  }

  Future<void> addPendingBill() async {
    final PendingBill? bill = await showDialog<PendingBill>(
      context: context,
      builder: (context) {
        return const _PendingBillDialog();
      },
    );

    if (bill != null) {
      await pendingBillController.addBill(bill);
    }
  }

  Future<void> editPendingBill(int index) async {
    final bill = pendingBillController.bills[index];

    final PendingBill? updatedBill =
        await showDialog<PendingBill>(
      context: context,
      builder: (context) {
        return _PendingBillDialog(
          bill: bill,
        );
      },
    );

    if (updatedBill != null) {
      await pendingBillController.updateBill(
        index,
        updatedBill,
      );
    }
  }

  Future<void> deletePendingBill(int index) async {
    final bill = pendingBillController.bills[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('પેન્ડિંગ બિલ કાઢી નાખવું છે?'),
          content: Text(
            'શું તમે "${bill.customerName}" નું પેન્ડિંગ બિલ કાઢી નાખવા માંગો છો?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('રદ કરો'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('કાઢી નાખો'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await pendingBillController.deleteBill(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('પેન્ડિંગ બિલ'),
      ),
      body: AnimatedBuilder(
        animation: pendingBillController,
        builder: (context, child) {
          if (pendingBillController.bills.isEmpty) {
            return const Center(
              child: Text(
                'હજુ કોઈ પેન્ડિંગ બિલ નથી.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingBillController.bills.length,
            itemBuilder: (context, index) {
              final bill = pendingBillController.bills[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    bill.customerName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(bill.date),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${bill.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'સુધારો',
                        onPressed: () {
                          editPendingBill(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'કાઢી નાખો',
                        onPressed: () {
                          deletePendingBill(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPendingBill,
        icon: const Icon(Icons.add),
        label: const Text('પેન્ડિંગ ઉમેરો'),
      ),
    );
  }
}

class _PendingBillDialog extends StatefulWidget {
  final PendingBill? bill;

  const _PendingBillDialog({
    this.bill,
  });

  @override
  State<_PendingBillDialog> createState() =>
      _PendingBillDialogState();
}

class _PendingBillDialogState
    extends State<_PendingBillDialog> {
  final TextEditingController customerController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  DateTime? selectedDate;

  bool get isEditing => widget.bill != null;

  @override
  void initState() {
    super.initState();

    if (widget.bill != null) {
      final bill = widget.bill!;

      customerController.text = bill.customerName;
      priceController.text = bill.price.toString();

      selectedDate = _parseDate(bill.date);
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    priceController.dispose();

    super.dispose();
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('/');

    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      selectedDate = pickedDate;
    });

    FocusScope.of(context).nextFocus();
  }

  Future<void> saveBill() async {
    final customerName = customerController.text.trim();

    final price = double.tryParse(
      priceController.text.trim(),
    );

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('તારીખ પસંદ કરો.'),
        ),
      );
      return;
    }

    if (customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ગ્રાહકનું નામ દાખલ કરો.'),
        ),
      );
      return;
    }

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('યોગ્ય ભાવ દાખલ કરો.'),
        ),
      );
      return;
    }

    final bill = PendingBill(
      id: widget.bill?.id,
      date: _formatDate(selectedDate!),
      customerName: customerName,
      price: price,
    );

    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(bill);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'પેન્ડિંગ બિલ સુધારો'
            : 'પેન્ડિંગ બિલ ઉમેરો',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'તારીખ',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                  ),
                ),
                child: Text(
                  selectedDate == null
                      ? 'તારીખ પસંદ કરો'
                      : _formatDate(selectedDate!),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: customerController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ગ્રાહકનું નામ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'ભાવ',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveBill();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('રદ કરો'),
        ),
        ElevatedButton(
          onPressed: saveBill,
          child: Text(
            isEditing ? 'સાચવો' : 'ઉમેરો',
          ),
        ),
      ],
    );
  }
}