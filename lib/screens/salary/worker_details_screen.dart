import 'package:flutter/material.dart';

import '../../controllers/worker_hours_controller.dart';
import '../../models/worker.dart';
import 'salary_preview_screen.dart';
import '../../controllers/worker_controller.dart';
import 'edit_worker_screen.dart';

class WorkerDetailsScreen extends StatefulWidget {
  final Worker worker;

  const WorkerDetailsScreen({super.key, required this.worker});

  @override
  State<WorkerDetailsScreen> createState() => _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState extends State<WorkerDetailsScreen> {
  final WorkerHoursController workerHoursController = WorkerHoursController();

  final TextEditingController hoursController = TextEditingController();
  final WorkerController workerController = WorkerController();
  bool isEditingToday = false;

  @override
  void initState() {
    super.initState();
    workerHoursController.loadWorkerHours(widget.worker.id!);
  }

  @override
  void dispose() {
    hoursController.dispose();
    workerHoursController.dispose();
    super.dispose();
  }

  Future<void> deleteWorker() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('કર્મચારી કાઢી નાખો?'),
          content: Text('${widget.worker.name} ને કાઢી નાખવા માંગો છો?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('ના'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('હા, કાઢી નાખો'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await workerController.loadWorkers();

    final index = workerController.workers.indexWhere(
      (worker) => worker.id == widget.worker.id,
    );

    if (index == -1) {
      return;
    }

    await workerController.deleteWorker(index);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> editWorker() async {
    final Worker? updatedWorker = await Navigator.of(context).push<Worker>(
      MaterialPageRoute(
        builder: (context) => EditWorkerScreen(worker: widget.worker),
      ),
    );

    if (updatedWorker == null) {
      return;
    }

    final index = workerController.workers.indexWhere(
      (worker) => worker.id == widget.worker.id,
    );

    if (index == -1) {
      await workerController.loadWorkers();
    }

    final workerIndex = workerController.workers.indexWhere(
      (worker) => worker.id == widget.worker.id,
    );

    if (workerIndex == -1) {
      return;
    }

    await workerController.updateWorker(workerIndex, updatedWorker);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> saveHours() async {
    final hours = double.tryParse(hoursController.text.trim());

    if (hours == null || hours < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('યોગ્ય કલાક દાખલ કરો.')));
      return;
    }

    await workerHoursController.saveTodayHours(
      workerId: widget.worker.id!,
      hours: hours,
    );

    hoursController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('આજના કલાક સેવ થઈ ગયા.')));
  }

  void startEditToday() {
    final todayEntry = workerHoursController.todayHours;

    if (todayEntry == null) {
      return;
    }

    setState(() {
      isEditingToday = true;

      hoursController.text = todayEntry.hours.toString();
    });
  }

  Future<void> updateHours() async {
    final hours = double.tryParse(hoursController.text.trim());

    if (hours == null || hours < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('યોગ્ય કલાક દાખલ કરો.')));
      return;
    }

    await workerHoursController.updateTodayHours(
      workerId: widget.worker.id!,
      hours: hours,
    );

    hoursController.clear();

    if (!mounted) return;

    setState(() {
      isEditingToday = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('આજના કલાક અપડેટ થઈ ગયા.')));
  }

  @override
  Widget build(BuildContext context) {
    final worker = widget.worker;

    final estimatedSalary =
        workerHoursController.currentMonthTotalHours * worker.hourlyRate;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.worker.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                editWorker();
              } else if (value == 'delete') {
                deleteWorker();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 10),
                    Text('કર્મચારીમાં ફેરફાર કરો'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 10),
                    Text('કર્મચારી કાઢી નાખો'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: workerHoursController,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'કલાક દીઠ દર: ₹${worker.hourlyRate.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (!workerHoursController.hasTodayEntry) ...[
                  const Text(
                    'આજના કામના કલાક',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: hoursController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'કલાક દાખલ કરો',
                      suffixText: 'કલાક',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      saveHours();
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: saveHours,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'કલાક સેવ કરો',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else if (!isEditingToday)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'આજના કલાક',
                            style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${workerHoursController.todayHours!.hours.toStringAsFixed(2)} કલાક',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: startEditToday,
                              icon: const Icon(Icons.edit),
                              label: const Text('આજના કલાક એડિટ કરો'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  const Text(
                    'આજના કલાક એડિટ કરો',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: hoursController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      suffixText: 'કલાક',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      updateHours();
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: updateHours,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'કલાક અપડેટ કરો',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'આ મહિનાનો સારાંશ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'કુલ કામના કલાક',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${workerHoursController.currentMonthTotalHours.toStringAsFixed(2)} કલાક',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'અંદાજિત પગાર',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '₹${estimatedSalary.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SalaryPreviewScreen(worker: widget.worker),
                        ),
                      );
                    },
                    icon: const Icon(Icons.print),
                    label: const Text(
                      'પગાર પ્રિન્ટ કરો',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
