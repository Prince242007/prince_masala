import 'package:flutter/material.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController hourlyRateController =
      TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode rateFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    hourlyRateController.dispose();
    nameFocus.dispose();
    rateFocus.dispose();
    super.dispose();
  }

  void saveWorker() {
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

    Navigator.of(context).pop();
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
      appBar: AppBar(
        title: const Text('કર્મચારી ઉમેરો'),
      ),
      resizeToAvoidBottomInset: true,
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
                hintText: 'કર્મચારીનું નામ દાખલ કરો',
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
                hintText: 'કલાક દીઠ દર દાખલ કરો',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                saveWorker();
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: saveWorker,
                icon: const Icon(Icons.save),
                label: const Text(
                  'ઉમેરો',
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