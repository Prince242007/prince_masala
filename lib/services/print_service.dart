import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/bill_item.dart';

class PrintService {
  static Future<void> printBill({
    required String customerName,
    required List<BillItem> items,
    required double total,
  }) async {
    await Printing.layoutPdf(
      name: 'Prince Masala Bill',
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async {
        final fontData = await rootBundle.load(
          'assets/fonts/NotoSansGujarati-Regular.ttf',
        );

        final gujaratiFont = pw.Font.ttf(
          fontData.buffer.asByteData(),
        );

        final pdf = pw.Document();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(36),
            build: (context) {
              return [
                pw.Center(
                  child: pw.Text(
                    'PRINCE MASALA',
                    style: pw.TextStyle(
                      fontSize: 22,
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

                pw.SizedBox(height: 10),

                pw.Row(
                  mainAxisAlignment:
                      pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Customer: $customerName',
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      'Date: ${DateTime.now().day}/'
                      '${DateTime.now().month}/'
                      '${DateTime.now().year}',
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 18),

                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(35),
                    1: const pw.FlexColumnWidth(4),
                    2: const pw.FlexColumnWidth(1.2),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(1.8),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        _headerCell('No.'),
                        _headerCell('Item'),
                        _headerCell('Qty'),
                        _headerCell('Rate'),
                        _headerCell('Amount'),
                      ],
                    ),

                    ...items.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return pw.TableRow(
                          children: [
                            _cell('${index + 1}'),

                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                item.gujaratiName,
                                style: pw.TextStyle(
                                  font: gujaratiFont,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            _cell('${item.quantity}'),

                            _cell(
                              'Rs. ${item.price.toStringAsFixed(2)}',
                            ),

                            _cell(
                              'Rs. ${item.amount.toStringAsFixed(2)}',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                    width: 220,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Row(
                      mainAxisAlignment:
                          pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'TOTAL',
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.Text(
                          'Rs. ${total.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(height: 40),

                pw.Center(
                  child: pw.Text(
                    'Thank You',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ];
            },
          ),
        );

        return pdf.save();
      },
    );
  }

  static pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}