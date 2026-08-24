import 'package:flutter/material.dart';

import '../../controllers/worker_controller.dart';
import '../../models/worker.dart';
import 'add_worker_screen.dart';
import 'worker_details_screen.dart';
import '../../controllers/worker_hours_controller.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  final WorkerController workerController = WorkerController();
  final WorkerHoursController workerHoursController = WorkerHoursController();

  @override
  void initState() {
    super.initState();
    workerController.loadWorkers();
  }

  @override
  void dispose() {
    workerController.dispose();
    workerHoursController.dispose();
    super.dispose();
  }

  Future<void> addWorker() async {
    final Worker? newWorker = await Navigator.of(context).push<Worker>(
      MaterialPageRoute(builder: (context) => const AddWorkerScreen()),
    );

    if (newWorker == null) {
      return;
    }

    try {
      await workerController.addWorker(newWorker);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('કર્મચારી સફળતાપૂર્વક ઉમેરાયો.')),
        );
    } catch (e) {
      debugPrint('ADD WORKER ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('કર્મચારી ઉમેરવામાં ભૂલ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('કર્મચારી પગાર')),
      body: AnimatedBuilder(
        animation: workerController,
        builder: (context, child) {
          if (workerController.workers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline, size: 70),

                    const SizedBox(height: 16),

                    const Text(
                      'હજુ કોઈ કર્મચારી ઉમેરાયો નથી.',
                      style: TextStyle(fontSize: 17),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: addWorker,
                        icon: const Icon(Icons.person_add),
                        label: const Text(
                          'કર્મચારી ઉમેરો',
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workerController.workers.length,
            itemBuilder: (context, index) {
              final worker = workerController.workers[index];

              return FutureBuilder<double>(
                future: worker.id == null
                    ? Future.value(0.0)
                    : workerHoursController.getCurrentMonthTotalForWorker(
                        worker.id!,
                      ),
                builder: (context, snapshot) {
                  final monthlyHours = snapshot.data ?? 0.0;

                  final monthlySalary = monthlyHours * worker.hourlyRate;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkerDetailsScreen(worker: worker),
                          ),
                        );

                        if (result == true) {
                          await workerController.loadWorkers();
                        }

                        setState(() {});
                      },
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        worker.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'કલાક દીઠ દર: ₹${worker.hourlyRate.toStringAsFixed(2)}',
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'આ મહિનાના કલાક: ${monthlyHours.toStringAsFixed(2)}',
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'આ મહિનાનો પગાર: ₹${monthlySalary.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addWorker,
        icon: const Icon(Icons.person_add),
        label: const Text('કર્મચારી ઉમેરો'),
      ),
    );
  }
}
