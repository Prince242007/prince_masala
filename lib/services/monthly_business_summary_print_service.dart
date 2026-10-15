import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MonthlyBusinessSummaryPrintService {
  static Future<void> printMonthlySummary({
    required Map<String, Map<String, dynamic>> monthlyData,
  }) async {
    final now = DateTime.now();

    final pdf = pw.Document();

    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;

    final totalBills = monthlyData.values.fold<int>(
      0,
      (sum, data) =>
          sum + ((data['bill_count'] as num?)?.toInt() ?? 0),
    );

    final totalAmount = monthlyData.values.fold<double>(
      0.0,
      (sum, data) =>
          sum + ((data['total'] as num?)?.toDouble() ?? 0.0),
    );

    String dateKey(int day) {
      return '${now.year}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${day.toString().padLeft(2, '0')}';
    }

    int getBillCount(int day) {
      final data = monthlyData[dateKey(day)];

      return (data?['bill_count'] as num?)?.toInt() ?? 0;
    }

    double getAmount(int day) {
      final data = monthlyData[dateKey(day)];

      return (data?['total'] as num?)?.toDouble() ?? 0.0;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
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

              pw.SizedBox(height: 15),

              pw.Center(
                child: pw.Text(
                  'Monthly Business Summary',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Center(
                child: pw.Text(
                  '${_getMonthName(now.month)} ${now.year}',
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),

              pw.SizedBox(height: 15),

              pw.Divider(),

              pw.SizedBox(height: 15),

              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _headerCell('Date'),
                      _headerCell('Bills'),
                      _headerCell('Amount'),
                      _headerCell('Date'),
                      _headerCell('Bills'),
                      _headerCell('Amount'),
                    ],
                  ),

                  for (int index = 0; index < 15; index++)
                    pw.TableRow(
                      children: [
                        _cell('${index + 1}'),

                        _cell(
                          '${getBillCount(index + 1)}',
                        ),

                        _cell(
                          'Rs. ${getAmount(index + 1).toStringAsFixed(2)}',
                        ),

                        if (index + 16 <= daysInMonth)
                          _cell('${index + 16}')
                        else
                          _cell(''),

                        if (index + 16 <= daysInMonth)
                          _cell(
                            '${getBillCount(index + 16)}',
                          )
                        else
                          _cell(''),

                        if (index + 16 <= daysInMonth)
                          _cell(
                            'Rs. ${getAmount(index + 16).toStringAsFixed(2)}',
                          )
                        else
                          _cell(''),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 20),

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
                        'Total Bills',
                        '$totalBills',
                      ),

                      pw.SizedBox(height: 8),

                      pw.Divider(),

                      _summaryRow(
                        'Total Amount',
                        'Rs. ${totalAmount.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  'Prince Masala - Monthly Business Statement',
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: 'Monthly_Business_Summary_${now.month}_${now.year}',
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
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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