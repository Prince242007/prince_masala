import 'package:flutter/material.dart';

import '../../models/worker.dart';

class EditWorkerScreen extends StatefulWidget {
  final Worker worker;

  const EditWorkerScreen({
    super.key,
    required this.worker,
  });

  @override
  State<EditWorkerScreen> createState() =>
      _EditWorkerScreenState();
}

class _EditWorkerScreenState
    extends State<EditWorkerScreen> {
  late final TextEditingController nameController;
  late final TextEditingController hourlyRateController;

  final FocusNode nameFocus = FocusNode();
  final FocusNode rateFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.worker.name,
    );

    hourlyRateController = TextEditingController(
      text: widget.worker.hourlyRate.toString(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    hourlyRateController.dispose();
    nameFocus.dispose();
    rateFocus.dispose();
    super.dispose();
  }

  void saveChanges() {
    final name = nameController.text.trim();

    final hourlyRate =
        double.tryParse(hourlyRateController.text.trim());

    if (name.isEmpty) {
      _showMessage('કર્મચારીનું નામ દાખલ કરો.');
      nameFocus.requestFocus();
      return;
    }

    if (hourlyRate == null || hourlyRate <= 0) {
      _showMessage('યોગ્ય કલાક દીઠ દર દાખલ કરો.');
      rateFocus.requestFocus();
      return;
    }

    final updatedWorker = Worker(
      id: widget.worker.id,
      name: name,
      hourlyRate: hourlyRate,
    );

    Navigator.of(context).pop(updatedWorker);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('કર્મચારીમાં ફેરફાર કરો'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'કર્મચારીનું નામ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              focusNode: nameFocus,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                rateFocus.requestFocus();
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'કલાક દીઠ દર',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: hourlyRateController,
              focusNode: rateFocus,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveChanges();
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: saveChanges,
                icon: const Icon(Icons.save),
                label: const Text(
                  'ફેરફાર સેવ કરો',
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
    );
  }
}