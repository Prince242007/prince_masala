import 'package:flutter/material.dart';

import '../../controllers/worker_hours_controller.dart';
import '../../controllers/worker_advance_controller.dart';
import '../../models/worker.dart';
import '../../models/worker_hours.dart';

import '../../services/salary_print_service.dart';

class SalaryPreviewScreen extends StatefulWidget {
  final Worker worker;

  const SalaryPreviewScreen({
    super.key,
    required this.worker,
  });

  @override
  State<SalaryPreviewScreen> createState() =>
      _SalaryPreviewScreenState();
}

class _SalaryPreviewScreenState
    extends State<SalaryPreviewScreen> {
  final WorkerHoursController workerHoursController =
      WorkerHoursController();

  final WorkerAdvanceController workerAdvanceController =
      WorkerAdvanceController();

  late Future<List<WorkerHours>> monthlyHoursFuture;

  @override
  void initState() {
    super.initState();

    monthlyHoursFuture =
        workerHoursController.getCurrentMonthHours(
      widget.worker.id!,
    );

    workerAdvanceController.loadAdvances(
      widget.worker.id!,
    );
  }

  @override
  void dispose() {
    workerHoursController.dispose();
    workerAdvanceController.dispose();
    super.dispose();
  }

  String getMonthName(int month) {
    const months = [
      'જાન્યુઆરી',
      'ફેબ્રુઆરી',
      'માર્ચ',
      'એપ્રિલ',
      'મે',
      'જૂન',
      'જુલાઈ',
      'ઓગસ્ટ',
      'સપ્ટેમ્બર',
      'ઓક્ટોબર',
      'નવેમ્બર',
      'ડિસેમ્બર',
    ];

    return months[month - 1];
  }

  int getDaysInCurrentMonth() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('પગાર વિગતો'),
      ),

      body: FutureBuilder<List<WorkerHours>>(
        future: monthlyHoursFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'માહિતી લોડ કરવામાં ભૂલ થઈ.',
              ),
            );
          }

          final entries = snapshot.data ?? [];

          final Map<int, double> hoursByDay = {};

          for (final entry in entries) {
            final date = DateTime.parse(entry.date);

            hoursByDay[date.day] = entry.hours;
          }

          final totalHours = entries.fold<double>(
            0,
            (sum, entry) => sum + entry.hours,
          );

          final totalSalary =
              totalHours * widget.worker.hourlyRate;

          final totalAdvance =
              workerAdvanceController.totalAdvance;

          final finalSalary =
              totalSalary - totalAdvance;

          final daysInMonth =
              getDaysInCurrentMonth();

          final leftDays =
              List.generate(
            15,
            (index) => index + 1,
          );

          final rightDays =
              List.generate(
            daysInMonth > 15
                ? daysInMonth - 15
                : 0,
            (index) => index + 16,
          );

          return AnimatedBuilder(
            animation: workerAdvanceController,
            builder: (context, child) {
              final currentTotalAdvance =
                  workerAdvanceController
                      .totalAdvance;

              final currentFinalSalary =
                  totalSalary -
                      currentTotalAdvance;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'PRINCE MASALA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'કર્મચારી પગાર વિગતો',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          'કર્મચારી: ${widget.worker.name}',
                          style:
                              const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        Text(
                          'મહિનો: ${getMonthName(now.month)} ${now.year}',
                          style:
                              const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment:
                          Alignment.centerLeft,
                      child: Text(
                        'કલાક દીઠ દર: ₹${widget.worker.hourlyRate.toStringAsFixed(2)}',
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =================================================
                    // EXISTING HOURS TABLE
                    // =================================================

                    Table(
                      border: TableBorder.all(),
                      columnWidths:
                          const {
                        0: FlexColumnWidth(
                          1.2,
                        ),
                        1: FlexColumnWidth(
                          1,
                        ),
                        2: FlexColumnWidth(
                          1.2,
                        ),
                        3: FlexColumnWidth(
                          1,
                        ),
                      },
                      children: [
                        const TableRow(
                          children: [
                            _TableHeader(
                              'તારીખ',
                            ),
                            _TableHeader(
                              'કલાક',
                            ),
                            _TableHeader(
                              'તારીખ',
                            ),
                            _TableHeader(
                              'કલાક',
                            ),
                          ],
                        ),

                        for (
                          int index = 0;
                          index < 15;
                          index++
                        )
                          TableRow(
                            children: [
                              _TableCell(
                                '${leftDays[index]}',
                              ),

                              _TableCell(
                                hoursByDay[
                                            leftDays[
                                                index]]
                                        ?.toStringAsFixed(
                                      2,
                                    ) ??
                                    '—',
                              ),

                              if (index <
                                  rightDays.length)
                                _TableCell(
                                  '${rightDays[index]}',
                                )
                              else
                                const _TableCell(
                                  '',
                                ),

                              if (index <
                                  rightDays.length)
                                _TableCell(
                                  hoursByDay[
                                              rightDays[
                                                  index]]
                                          ?.toStringAsFixed(
                                        2,
                                      ) ??
                                      '—',
                                )
                              else
                                const _TableCell(
                                  '',
                                ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =================================================
                    // SALARY SUMMARY
                    // =================================================

                    Align(
                      alignment:
                          Alignment.centerRight,
                      child: Container(
                        width: 250,
                        padding:
                            const EdgeInsets.all(
                          14,
                        ),
                        decoration:
                            BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              label:
                                  'કુલ કામના કલાક',
                              value:
                                  totalHours
                                      .toStringAsFixed(
                                2,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            _SummaryRow(
                              label:
                                  'કલાક દીઠ દર',
                              value:
                                  '₹${widget.worker.hourlyRate.toStringAsFixed(2)}',
                            ),

                            const Divider(),

                            _SummaryRow(
                              label:
                                  'કુલ પગાર',
                              value:
                                  '₹${totalSalary.toStringAsFixed(2)}',
                              isBold: true,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            _SummaryRow(
                              label:
                                  'કુલ એડવાન્સ',
                              value:
                                  '₹${currentTotalAdvance.toStringAsFixed(2)}',
                            ),

                            const Divider(),

                            _SummaryRow(
                              label:
                                  'આપવાનો પગાર',
                              value:
                                  '₹${currentFinalSalary.toStringAsFixed(2)}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =================================================
                    // PRINT BUTTON
                    // =================================================

                    SizedBox(
                      width:
                          double.infinity,
                      height: 52,
                      child:
                          ElevatedButton.icon(
                        onPressed: () async {
                          await SalaryPrintService
                              .printSalary(
                            worker:
                                widget.worker,
                            entries:
                                entries,
                            totalAdvance:
                                currentTotalAdvance,
                          );
                        },
                        icon: const Icon(
                          Icons.print,
                        ),
                        label: const Text(
                          'પગાર પ્રિન્ટ કરો',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign:
            TextAlign.center,
        style:
            const TextStyle(
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 4,
      ),
      child: Text(
        text,
        textAlign:
            TextAlign.center,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold
          ? FontWeight.bold
          : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
    );

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style,
        ),
        Text(
          value,
          style: style,
        ),
      ],
    );
  }
} 