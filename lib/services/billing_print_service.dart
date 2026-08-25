import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../models/bill_item.dart';

class BillingPrintService {
  static Future<void> printBill({
    required String customerName,
    required List<BillItem> items,
    required double total,
  }) async {
    final fontData = await rootBundle.load(
      'assets/fonts/NotoSansGujarati-Regular.ttf',
    );

    final gujaratiFont = pw.Font.ttf(fontData.buffer.asByteData());
    final pdf = pw.Document();

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
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.SizedBox(height: 12),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Customer: $customerName',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(
                    'Date: ${DateTime.now().day}/'
                    '${DateTime.now().month}/'
                    '${DateTime.now().year}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

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

                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return pw.TableRow(
                      children: [
                        _cell('${index + 1}'),

                        // Temporary English-safe item text
                        // _cell(item.gujaratiName),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            item.gujaratiName,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: gujaratiFont,
                              fontSize: 10,
                            ),
                          ),
                        ),

                        _cell('${item.quantity}'),

                        _cell('Rs. ${item.price.toStringAsFixed(2)}'),

                        _cell('Rs. ${item.amount.toStringAsFixed(2)}'),
                      ],
                    );
                  }),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 230,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'TOTAL',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.Text(
                        'Rs. ${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  'Thank You',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: 'Prince Masala Bill',
      onLayout: (format) async {
        return pdf.save();
      },
    );
  }

  static pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }
}
