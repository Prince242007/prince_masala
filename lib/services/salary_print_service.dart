import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/worker.dart';
import '../models/worker_hours.dart';

class SalaryPrintService {
  static Future<void> printSalary({
    required Worker worker,
    required List<WorkerHours> entries,
  }) async {
    final now = DateTime.now();

    final pdf = pw.Document();

    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;

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
        totalHours * worker.hourlyRate;

    final monthName = _getMonthName(now.month);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),

        build: (context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'PRINCE MASALA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Center(
                child: pw.Text(
                  'Spices & Dryfruits',
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.SizedBox(height: 15),

              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Worker: ${worker.name}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(
                    'Month: $monthName ${now.year}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                'Hourly Rate: Rs. ${worker.hourlyRate.toStringAsFixed(2)}',
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.2),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1.2),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _headerCell('Date'),
                      _headerCell('Hours'),
                      _headerCell('Date'),
                      _headerCell('Hours'),
                    ],
                  ),

                  for (int index = 0; index < 15; index++)
                    pw.TableRow(
                      children: [
                        _cell('${index + 1}'),

                        _cell(
                          hoursByDay[index + 1]
                                  ?.toStringAsFixed(2) ??
                              '-',
                        ),

                        if (index + 16 <= daysInMonth)
                          _cell('${index + 16}')
                        else
                          _cell(''),

                        if (index + 16 <= daysInMonth)
                          _cell(
                            hoursByDay[index + 16]
                                    ?.toStringAsFixed(2) ??
                                '-',
                          )
                        else
                          _cell(''),
                      ],
                    ),
                ],
              ),

              pw.Spacer(),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 230,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    children: [
                      _summaryRow(
                        'Total Hours',
                        totalHours.toStringAsFixed(2),
                      ),

                      pw.SizedBox(height: 8),

                      _summaryRow(
                        'Hourly Rate',
                        'Rs. ${worker.hourlyRate.toStringAsFixed(2)}',
                      ),

                      pw.Divider(),

                      _summaryRow(
                        'Total Salary',
                        'Rs. ${totalSalary.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  'Salary Statement',
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name:
          'Salary_${worker.name}_${now.month}_${now.year}',
      onLayout: (format) async {
        return pdf.save();
      },
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  static pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  static pw.Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    final style = pw.TextStyle(
      fontSize: isBold ? 12 : 10,
      fontWeight:
          isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );

    return pw.Row(
      mainAxisAlignment:
          pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: style,
        ),
        pw.Text(
          value,
          style: style,
        ),
      ],
    );
  }
}