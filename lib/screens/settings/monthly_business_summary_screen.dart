import 'package:flutter/material.dart';

import '../../controllers/daily_bill_summary_controller.dart';
import '../../services/monthly_business_summary_print_service.dart';

class MonthlyBusinessSummaryScreen extends StatefulWidget {
  const MonthlyBusinessSummaryScreen({super.key});

  @override
  State<MonthlyBusinessSummaryScreen> createState() =>
      _MonthlyBusinessSummaryScreenState();
}

class _MonthlyBusinessSummaryScreenState
    extends State<MonthlyBusinessSummaryScreen> {
  final DailyBillSummaryController dailyBillSummaryController =
      DailyBillSummaryController();

  Map<String, Map<String, dynamic>> monthlyData = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadMonthlyData();
  }

  Future<void> _loadMonthlyData() async {
    setState(() {
      isLoading = true;
    });

    final data =
        await dailyBillSummaryController.getCurrentMonthSummary();

    if (!mounted) return;

    setState(() {
      monthlyData = data;
      isLoading = false;
    });
  }

  Future<void> _printMonthlySummary() async {
    try {
      await MonthlyBusinessSummaryPrintService.printMonthlySummary(
        monthlyData: monthlyData,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'રિપોર્ટ પ્રિન્ટ કરવામાં ભૂલ: $e',
          ),
        ),
      );
    }
  }

  int get daysInCurrentMonth {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;
  }

  String get currentMonthName {
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

    return months[DateTime.now().month - 1];
  }

  String _dateKey(int day) {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  int _billCount(int day) {
    final data = monthlyData[_dateKey(day)];

    return (data?['bill_count'] as num?)?.toInt() ?? 0;
  }

  double _amount(int day) {
    final data = monthlyData[_dateKey(day)];

    return (data?['total'] as num?)?.toDouble() ?? 0.0;
  }

  int get totalBills {
    int total = 0;

    for (final data in monthlyData.values) {
      total += (data['bill_count'] as num?)?.toInt() ?? 0;
    }

    return total;
  }

  double get totalAmount {
    double total = 0.0;

    for (final data in monthlyData.values) {
      total += (data['total'] as num?)?.toDouble() ?? 0.0;
    }

    return total;
  }

  @override
  void dispose() {
    dailyBillSummaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('માસિક વેપાર સારાંશ'),

        actions: [
          IconButton(
            onPressed:
                isLoading ? null : _printMonthlySummary,

            icon: const Icon(Icons.print),

            tooltip: 'પ્રિન્ટ',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            Text(
              '$currentMonthName ${DateTime.now().year}',

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 18,

                        columns: const [
                          DataColumn(
                            label: Text(
                              'તારીખ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'બિલ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'રકમ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'તારીખ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'બિલ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'રકમ',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],

                        rows: List.generate(
                          15,

                          (index) {
                            final leftDay = index + 1;

                            final rightDay = index + 16;

                            final rightDayExists =
                                rightDay <=
                                    daysInCurrentMonth;

                            return DataRow(
                              cells: [
                                DataCell(
                                  Text('$leftDay'),
                                ),

                                DataCell(
                                  Text(
                                    '${_billCount(leftDay)}',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    '₹${_amount(leftDay).toStringAsFixed(2)}',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    rightDayExists
                                        ? '$rightDay'
                                        : '',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    rightDayExists
                                        ? '${_billCount(rightDay)}'
                                        : '',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    rightDayExists
                                        ? '₹${_amount(rightDay).toStringAsFixed(2)}'
                                        : '',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    _summaryRow(
                      'કુલ બિલ',
                      '$totalBills',
                    ),

                    const SizedBox(height: 8),

                    _summaryRow(
                      'કુલ રકમ',
                      '₹${totalAmount.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}