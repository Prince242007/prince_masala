// // import 'package:flutter/material.dart';

// // import '../../controllers/worker_hours_controller.dart';
// // import '../../models/worker.dart';
// // import 'salary_preview_screen.dart';
// // import '../../controllers/worker_controller.dart';
// // import 'edit_worker_screen.dart';

// // class WorkerDetailsScreen extends StatefulWidget {
// //   final Worker worker;

// //   const WorkerDetailsScreen({super.key, required this.worker});

// //   @override
// //   State<WorkerDetailsScreen> createState() => _WorkerDetailsScreenState();
// // }

// // class _WorkerDetailsScreenState extends State<WorkerDetailsScreen> {
// //   final WorkerHoursController workerHoursController = WorkerHoursController();

// //   final TextEditingController hoursController = TextEditingController();
// //   final WorkerController workerController = WorkerController();
// //   bool isEditingToday = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     workerHoursController.loadWorkerHours(widget.worker.id!);
// //   }

// //   @override
// //   void dispose() {
// //     hoursController.dispose();
// //     workerHoursController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> deleteWorker() async {
// //     final bool? shouldDelete = await showDialog<bool>(
// //       context: context,
// //       builder: (dialogContext) {
// //         return AlertDialog(
// //           title: const Text('કર્મચારી કાઢી નાખો?'),
// //           content: Text('${widget.worker.name} ને કાઢી નાખવા માંગો છો?'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(dialogContext).pop(false);
// //               },
// //               child: const Text('ના'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.of(dialogContext).pop(true);
// //               },
// //               child: const Text('હા, કાઢી નાખો'),
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (shouldDelete != true) {
// //       return;
// //     }

// //     await workerController.loadWorkers();

// //     final index = workerController.workers.indexWhere(
// //       (worker) => worker.id == widget.worker.id,
// //     );

// //     if (index == -1) {
// //       return;
// //     }

// //     await workerController.deleteWorker(index);

// //     if (!mounted) {
// //       return;
// //     }

// //     Navigator.of(context).pop(true);
// //   }

// //   Future<void> editWorker() async {
// //     final Worker? updatedWorker = await Navigator.of(context).push<Worker>(
// //       MaterialPageRoute(
// //         builder: (context) => EditWorkerScreen(worker: widget.worker),
// //       ),
// //     );

// //     if (updatedWorker == null) {
// //       return;
// //     }

// //     final index = workerController.workers.indexWhere(
// //       (worker) => worker.id == widget.worker.id,
// //     );

// //     if (index == -1) {
// //       await workerController.loadWorkers();
// //     }

// //     final workerIndex = workerController.workers.indexWhere(
// //       (worker) => worker.id == widget.worker.id,
// //     );

// //     if (workerIndex == -1) {
// //       return;
// //     }

// //     await workerController.updateWorker(workerIndex, updatedWorker);

// //     if (!mounted) {
// //       return;
// //     }

// //     Navigator.of(context).pop(true);
// //   }

// //   Future<void> saveHours() async {
// //     final hours = double.tryParse(hoursController.text.trim());

// //     if (hours == null || hours < 0) {
// //       ScaffoldMessenger.of(context)
// //         ..hideCurrentSnackBar()
// //         ..showSnackBar(const SnackBar(content: Text('યોગ્ય કલાક દાખલ કરો.')));
// //       return;
// //     }

// //     await workerHoursController.saveTodayHours(
// //       workerId: widget.worker.id!,
// //       hours: hours,
// //     );

// //     hoursController.clear();

// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context)
// //       ..hideCurrentSnackBar()
// //       ..showSnackBar(const SnackBar(content: Text('આજના કલાક સેવ થઈ ગયા.')));
// //   }

// //   void startEditToday() {
// //     final todayEntry = workerHoursController.todayHours;

// //     if (todayEntry == null) {
// //       return;
// //     }

// //     setState(() {
// //       isEditingToday = true;

// //       hoursController.text = todayEntry.hours.toString();
// //     });
// //   }

// //   Future<void> updateHours() async {
// //     final hours = double.tryParse(hoursController.text.trim());

// //     if (hours == null || hours < 0) {
// //       ScaffoldMessenger.of(context)
// //         ..hideCurrentSnackBar()
// //         ..showSnackBar(const SnackBar(content: Text('યોગ્ય કલાક દાખલ કરો.')));
// //       return;
// //     }

// //     await workerHoursController.updateTodayHours(
// //       workerId: widget.worker.id!,
// //       hours: hours,
// //     );

// //     hoursController.clear();

// //     if (!mounted) return;

// //     setState(() {
// //       isEditingToday = false;
// //     });

// //     ScaffoldMessenger.of(context)
// //       ..hideCurrentSnackBar()
// //       ..showSnackBar(const SnackBar(content: Text('આજના કલાક અપડેટ થઈ ગયા.')));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final worker = widget.worker;

// //     final estimatedSalary =
// //         workerHoursController.currentMonthTotalHours * worker.hourlyRate;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.worker.name),
// //         actions: [
// //           PopupMenuButton<String>(
// //             onSelected: (value) {
// //               if (value == 'edit') {
// //                 editWorker();
// //               } else if (value == 'delete') {
// //                 deleteWorker();
// //               }
// //             },
// //             itemBuilder: (context) => [
// //               const PopupMenuItem(
// //                 value: 'edit',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.edit_outlined),
// //                     SizedBox(width: 10),
// //                     Text('કર્મચારીમાં ફેરફાર કરો'),
// //                   ],
// //                 ),
// //               ),
// //               const PopupMenuItem(
// //                 value: 'delete',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.delete_outline),
// //                     SizedBox(width: 10),
// //                     Text('કર્મચારી કાઢી નાખો'),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //       body: AnimatedBuilder(
// //         animation: workerHoursController,
// //         builder: (context, child) {
// //           return SingleChildScrollView(
// //             padding: EdgeInsets.fromLTRB(
// //               16,
// //               16,
// //               16,
// //               MediaQuery.of(context).viewInsets.bottom + 16,
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Card(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(16),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           worker.name,
// //                           style: const TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),

// //                         const SizedBox(height: 8),

// //                         Text(
// //                           'કલાક દીઠ દર: ₹${worker.hourlyRate.toStringAsFixed(2)}',
// //                           style: const TextStyle(fontSize: 16),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 const SizedBox(height: 24),

// //                 if (!workerHoursController.hasTodayEntry) ...[
// //                   const Text(
// //                     'આજના કામના કલાક',
// //                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
// //                   ),

// //                   const SizedBox(height: 8),

// //                   TextField(
// //                     controller: hoursController,
// //                     keyboardType: const TextInputType.numberWithOptions(
// //                       decimal: true,
// //                     ),
// //                     textInputAction: TextInputAction.done,
// //                     decoration: const InputDecoration(
// //                       hintText: 'કલાક દાખલ કરો',
// //                       suffixText: 'કલાક',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     onSubmitted: (_) {
// //                       saveHours();
// //                     },
// //                   ),

// //                   const SizedBox(height: 16),

// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 52,
// //                     child: ElevatedButton.icon(
// //                       onPressed: saveHours,
// //                       icon: const Icon(Icons.save),
// //                       label: const Text(
// //                         'કલાક સેવ કરો',
// //                         style: TextStyle(
// //                           fontSize: 17,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ] else if (!isEditingToday)
// //                   Card(
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(16),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           const Text(
// //                             'આજના કલાક',
// //                             style: TextStyle(fontSize: 16),
// //                           ),

// //                           const SizedBox(height: 8),

// //                           Text(
// //                             '${workerHoursController.todayHours!.hours.toStringAsFixed(2)} કલાક',
// //                             style: const TextStyle(
// //                               fontSize: 24,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),

// //                           const SizedBox(height: 16),

// //                           SizedBox(
// //                             width: double.infinity,
// //                             child: OutlinedButton.icon(
// //                               onPressed: startEditToday,
// //                               icon: const Icon(Icons.edit),
// //                               label: const Text('આજના કલાક એડિટ કરો'),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //                 else ...[
// //                   const Text(
// //                     'આજના કલાક એડિટ કરો',
// //                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
// //                   ),

// //                   const SizedBox(height: 8),

// //                   TextField(
// //                     controller: hoursController,
// //                     keyboardType: const TextInputType.numberWithOptions(
// //                       decimal: true,
// //                     ),
// //                     textInputAction: TextInputAction.done,
// //                     decoration: const InputDecoration(
// //                       suffixText: 'કલાક',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     onSubmitted: (_) {
// //                       updateHours();
// //                     },
// //                   ),

// //                   const SizedBox(height: 16),

// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 52,
// //                     child: ElevatedButton.icon(
// //                       onPressed: updateHours,
// //                       icon: const Icon(Icons.save),
// //                       label: const Text(
// //                         'કલાક અપડેટ કરો',
// //                         style: TextStyle(
// //                           fontSize: 17,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],

// //                 const SizedBox(height: 30),

// //                 Card(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(18),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'આ મહિનાનો સારાંશ',
// //                           style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),

// //                         const SizedBox(height: 18),

// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             const Text(
// //                               'કુલ કામના કલાક',
// //                               style: TextStyle(fontSize: 16),
// //                             ),
// //                             Text(
// //                               '${workerHoursController.currentMonthTotalHours.toStringAsFixed(2)} કલાક',
// //                               style: const TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         const SizedBox(height: 12),

// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             const Text(
// //                               'અંદાજિત પગાર',
// //                               style: TextStyle(fontSize: 16),
// //                             ),
// //                             Text(
// //                               '₹${estimatedSalary.toStringAsFixed(2)}',
// //                               style: const TextStyle(
// //                                 fontSize: 17,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 24),

// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 52,
// //                   child: ElevatedButton.icon(
// //                     onPressed: () {
// //                       Navigator.of(context).push(
// //                         MaterialPageRoute(
// //                           builder: (context) =>
// //                               SalaryPreviewScreen(worker: widget.worker),
// //                         ),
// //                       );
// //                     },
// //                     icon: const Icon(Icons.print),
// //                     label: const Text(
// //                       'પગાર પ્રિન્ટ કરો',
// //                       style: TextStyle(
// //                         fontSize: 17,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// import '../../controllers/worker_hours_controller.dart';
// import '../../controllers/worker_advance_controller.dart';
// import '../../models/worker.dart';
// import '../../models/worker_advance.dart';
// import 'salary_preview_screen.dart';
// import '../../controllers/worker_controller.dart';
// import 'edit_worker_screen.dart';

// class WorkerDetailsScreen extends StatefulWidget {
//   final Worker worker;

//   const WorkerDetailsScreen({
//     super.key,
//     required this.worker,
//   });

//   @override
//   State<WorkerDetailsScreen> createState() =>
//       _WorkerDetailsScreenState();
// }

// class _WorkerDetailsScreenState
//     extends State<WorkerDetailsScreen> {
//   final WorkerHoursController workerHoursController =
//       WorkerHoursController();

//   final WorkerAdvanceController workerAdvanceController =
//       WorkerAdvanceController();

//   final TextEditingController hoursController =
//       TextEditingController();

//   final WorkerController workerController =
//       WorkerController();

//   bool isEditingToday = false;

//   @override
//   void initState() {
//     super.initState();

//     workerHoursController.loadWorkerHours(
//       widget.worker.id!,
//     );

//     workerAdvanceController.loadAdvances(
//       widget.worker.id!,
//     );
//   }

//   @override
//   void dispose() {
//     hoursController.dispose();
//     workerHoursController.dispose();
//     workerAdvanceController.dispose();
//     super.dispose();
//   }

//   Future<void> deleteWorker() async {
//     final bool? shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('કર્મચારી કાઢી નાખો?'),
//           content: Text(
//             '${widget.worker.name} ને કાઢી નાખવા માંગો છો?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(false);
//               },
//               child: const Text('ના'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(true);
//               },
//               child: const Text('હા, કાઢી નાખો'),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldDelete != true) {
//       return;
//     }

//     await workerController.loadWorkers();

//     final index = workerController.workers.indexWhere(
//       (worker) => worker.id == widget.worker.id,
//     );

//     if (index == -1) {
//       return;
//     }

//     await workerController.deleteWorker(index);

//     if (!mounted) {
//       return;
//     }

//     Navigator.of(context).pop(true);
//   }

//   Future<void> editWorker() async {
//     final Worker? updatedWorker =
//         await Navigator.of(context).push<Worker>(
//       MaterialPageRoute(
//         builder: (context) =>
//             EditWorkerScreen(worker: widget.worker),
//       ),
//     );

//     if (updatedWorker == null) {
//       return;
//     }

//     final index = workerController.workers.indexWhere(
//       (worker) => worker.id == widget.worker.id,
//     );

//     if (index == -1) {
//       await workerController.loadWorkers();
//     }

//     final workerIndex =
//         workerController.workers.indexWhere(
//       (worker) => worker.id == widget.worker.id,
//     );

//     if (workerIndex == -1) {
//       return;
//     }

//     await workerController.updateWorker(
//       workerIndex,
//       updatedWorker,
//     );

//     if (!mounted) {
//       return;
//     }

//     Navigator.of(context).pop(true);
//   }

//   Future<void> saveHours() async {
//     final hours =
//         double.tryParse(hoursController.text.trim());

//     if (hours == null || hours < 0) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('યોગ્ય કલાક દાખલ કરો.'),
//           ),
//         );
//       return;
//     }

//     await workerHoursController.saveTodayHours(
//       workerId: widget.worker.id!,
//       hours: hours,
//     );

//     hoursController.clear();

//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         const SnackBar(
//           content: Text('આજના કલાક સેવ થઈ ગયા.'),
//         ),
//       );
//   }

//   void startEditToday() {
//     final todayEntry =
//         workerHoursController.todayHours;

//     if (todayEntry == null) {
//       return;
//     }

//     setState(() {
//       isEditingToday = true;
//       hoursController.text =
//           todayEntry.hours.toString();
//     });
//   }

//   Future<void> updateHours() async {
//     final hours =
//         double.tryParse(hoursController.text.trim());

//     if (hours == null || hours < 0) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('યોગ્ય કલાક દાખલ કરો.'),
//           ),
//         );
//       return;
//     }

//     await workerHoursController.updateTodayHours(
//       workerId: widget.worker.id!,
//       hours: hours,
//     );

//     hoursController.clear();

//     if (!mounted) return;

//     setState(() {
//       isEditingToday = false;
//     });

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         const SnackBar(
//           content: Text('આજના કલાક અપડેટ થઈ ગયા.'),
//         ),
//       );
//   }

//   // ------------------------------------------------------------
//   // ADD ADVANCE
//   // ------------------------------------------------------------

//   Future<void> addAdvance() async {
//     final reasonController =
//         TextEditingController();

//     final amountController =
//         TextEditingController();

//     final bool? saved = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('ઉધાર / એડવાન્સ ઉમેરો'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: reasonController,
//                   textInputAction: TextInputAction.next,
//                   decoration: const InputDecoration(
//                     labelText: 'શા માટે?',
//                     hintText: 'જેમ કે Kaju 100 gm',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 TextField(
//                   controller: amountController,
//                   keyboardType:
//                       const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                   textInputAction:
//                       TextInputAction.done,
//                   decoration: const InputDecoration(
//                     labelText: 'રકમ',
//                     prefixText: '₹ ',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(false);
//               },
//               child: const Text('રદ કરો'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final reason =
//                     reasonController.text.trim();

//                 final amount =
//                     double.tryParse(
//                   amountController.text.trim(),
//                 );

//                 if (reason.isEmpty) {
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text('કારણ દાખલ કરો.'),
//                       ),
//                     );
//                   return;
//                 }

//                 if (amount == null || amount <= 0) {
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text('યોગ્ય રકમ દાખલ કરો.'),
//                       ),
//                     );
//                   return;
//                 }

//                 await workerAdvanceController
//                     .addAdvance(
//                   workerId: widget.worker.id!,
//                   reason: reason,
//                   amount: amount,
//                 );

//                 if (!mounted) return;

//                 Navigator.of(dialogContext)
//                     .pop(true);
//               },
//               child: const Text('સેવ કરો'),
//             ),
//           ],
//         );
//       },
//     );

//     reasonController.dispose();
//     amountController.dispose();

//     if (saved == true && mounted) {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(
//             content:
//                 Text('એડવાન્સ સેવ થઈ ગયું.'),
//           ),
//         );
//     }
//   }

//   // ------------------------------------------------------------
//   // DELETE ADVANCE
//   // ------------------------------------------------------------

//   Future<void> deleteAdvance(
//     WorkerAdvance advance,
//   ) async {
//     final bool? shouldDelete =
//         await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text(
//             'એડવાન્સ કાઢી નાખો?',
//           ),
//           content: Text(
//             '₹${advance.amount.toStringAsFixed(2)} '
//             'નું એડવાન્સ કાઢી નાખવું છે?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext)
//                     .pop(false);
//               },
//               child: const Text('ના'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(dialogContext)
//                     .pop(true);
//               },
//               child: const Text(
//                 'હા, કાઢી નાખો',
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldDelete != true) {
//       return;
//     }

//     await workerAdvanceController
//         .deleteAdvance(
//       advance.id!,
//       widget.worker.id!,
//     );
//   }

//   // ------------------------------------------------------------
//   // DATE FORMAT
//   // ------------------------------------------------------------

//   String formatDate(String date) {
//     final parts = date.split('-');

//     if (parts.length != 3) {
//       return date;
//     }

//     return '${parts[2]}/${parts[1]}/${parts[0]}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final worker = widget.worker;

//     final estimatedSalary =
//         workerHoursController.currentMonthTotalHours *
//             worker.hourlyRate;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.worker.name),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'edit') {
//                 editWorker();
//               } else if (value == 'delete') {
//                 deleteWorker();
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'edit',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit_outlined),
//                     SizedBox(width: 10),
//                     Text(
//                       'કર્મચારીમાં ફેરફાર કરો',
//                     ),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'delete',
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete_outline),
//                     SizedBox(width: 10),
//                     Text(
//                       'કર્મચારી કાઢી નાખો',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),

//       body: AnimatedBuilder(
//         animation: workerHoursController,
//         builder: (context, child) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//               16,
//               16,
//               16,
//               MediaQuery.of(context)
//                       .viewInsets
//                       .bottom +
//                   16,
//             ),
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 // ------------------------------------------------
//                 // WORKER INFORMATION
//                 // ------------------------------------------------

//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           worker.name,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 8),

//                         Text(
//                           'કલાક દીઠ દર: '
//                           '₹${worker.hourlyRate.toStringAsFixed(2)}',
//                           style:
//                               const TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // ------------------------------------------------
//                 // TODAY HOURS
//                 // ------------------------------------------------

//                 if (!workerHoursController
//                     .hasTodayEntry) ...[
//                   const Text(
//                     'આજના કામના કલાક',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight:
//                           FontWeight.w600,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   TextField(
//                     controller: hoursController,
//                     keyboardType:
//                         const TextInputType
//                             .numberWithOptions(
//                       decimal: true,
//                     ),
//                     textInputAction:
//                         TextInputAction.done,
//                     decoration:
//                         const InputDecoration(
//                       hintText:
//                           'કલાક દાખલ કરો',
//                       suffixText: 'કલાક',
//                       border:
//                           OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) {
//                       saveHours();
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child:
//                         ElevatedButton.icon(
//                       onPressed: saveHours,
//                       icon:
//                           const Icon(Icons.save),
//                       label: const Text(
//                         'કલાક સેવ કરો',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight:
//                               FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ] else if (!isEditingToday)
//                   Card(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment:
//                             CrossAxisAlignment
//                                 .start,
//                         children: [
//                           const Text(
//                             'આજના કલાક',
//                             style: TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),

//                           const SizedBox(height: 8),

//                           Text(
//                             '${workerHoursController.todayHours!.hours.toStringAsFixed(2)} કલાક',
//                             style:
//                                 const TextStyle(
//                               fontSize: 24,
//                               fontWeight:
//                                   FontWeight.bold,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           SizedBox(
//                             width: double.infinity,
//                             child:
//                                 OutlinedButton
//                                     .icon(
//                               onPressed:
//                                   startEditToday,
//                               icon: const Icon(
//                                 Icons.edit,
//                               ),
//                               label: const Text(
//                                 'આજના કલાક એડિટ કરો',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else ...[
//                   const Text(
//                     'આજના કલાક એડિટ કરો',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight:
//                           FontWeight.w600,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   TextField(
//                     controller: hoursController,
//                     keyboardType:
//                         const TextInputType
//                             .numberWithOptions(
//                       decimal: true,
//                     ),
//                     textInputAction:
//                         TextInputAction.done,
//                     decoration:
//                         const InputDecoration(
//                       suffixText: 'કલાક',
//                       border:
//                           OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) {
//                       updateHours();
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child:
//                         ElevatedButton.icon(
//                       onPressed: updateHours,
//                       icon:
//                           const Icon(Icons.save),
//                       label: const Text(
//                         'કલાક અપડેટ કરો',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight:
//                               FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 30),

//                 // ------------------------------------------------
//                 // MONTHLY SALARY SUMMARY
//                 // ------------------------------------------------

//                 Card(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.all(18),
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment
//                               .start,
//                       children: [
//                         const Text(
//                           'આ મહિનાનો સારાંશ',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 18),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment
//                                   .spaceBetween,
//                           children: [
//                             const Text(
//                               'કુલ કામના કલાક',
//                               style:
//                                   TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               '${workerHoursController.currentMonthTotalHours.toStringAsFixed(2)} કલાક',
//                               style:
//                                   const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight:
//                                     FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment
//                                   .spaceBetween,
//                           children: [
//                             const Text(
//                               'અંદાજિત પગાર',
//                               style:
//                                   TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               '₹${estimatedSalary.toStringAsFixed(2)}',
//                               style:
//                                   const TextStyle(
//                                 fontSize: 17,
//                                 fontWeight:
//                                     FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // ------------------------------------------------
//                 // ADVANCE / BORROW SECTION
//                 // ------------------------------------------------

//                 AnimatedBuilder(
//                   animation:
//                       workerAdvanceController,
//                   builder:
//                       (context, child) {
//                     final advances =
//                         workerAdvanceController
//                             .advances;

//                     final totalAdvance =
//                         workerAdvanceController
//                             .totalAdvance;

//                     return Card(
//                       child: Padding(
//                         padding:
//                             const EdgeInsets.all(
//                                 18),
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment
//                                   .start,
//                           children: [
//                             Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment
//                                       .spaceBetween,
//                               children: [
//                                 const Text(
//                                   'ઉધાર / એડવાન્સ',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight:
//                                         FontWeight
//                                             .bold,
//                                   ),
//                                 ),

//                                 IconButton(
//                                   onPressed:
//                                       addAdvance,
//                                   icon: const Icon(
//                                     Icons.add_circle,
//                                     size: 30,
//                                   ),
//                                   tooltip:
//                                       'એડવાન્સ ઉમેરો',
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 8),

//                             if (advances.isEmpty)
//                               const Padding(
//                                 padding:
//                                     EdgeInsets
//                                         .symmetric(
//                                   vertical: 12,
//                                 ),
//                                 child: Text(
//                                   'હજુ કોઈ એડવાન્સ લીધું નથી.',
//                                   style: TextStyle(
//                                     color:
//                                         Colors.grey,
//                                   ),
//                                 ),
//                               )
//                             else
//                               ListView.separated(
//                                 shrinkWrap: true,
//                                 physics:
//                                     const NeverScrollableScrollPhysics(),
//                                 itemCount:
//                                     advances.length,
//                                 separatorBuilder:
//                                     (context, index) =>
//                                         const Divider(
//                                   height: 1,
//                                 ),
//                                 itemBuilder:
//                                     (context, index) {
//                                   final advance =
//                                       advances[index];

//                                   return ListTile(
//                                     contentPadding:
//                                         EdgeInsets
//                                             .zero,
//                                     title: Text(
//                                       advance.reason,
//                                       style:
//                                           const TextStyle(
//                                         fontWeight:
//                                             FontWeight
//                                                 .w600,
//                                       ),
//                                     ),
//                                     subtitle:
//                                         Text(
//                                       formatDate(
//                                         advance.date,
//                                       ),
//                                     ),
//                                     trailing: Row(
//                                       mainAxisSize:
//                                           MainAxisSize
//                                               .min,
//                                       children: [
//                                         Text(
//                                           '₹${advance.amount.toStringAsFixed(2)}',
//                                           style:
//                                               const TextStyle(
//                                             fontSize:
//                                                 16,
//                                             fontWeight:
//                                                 FontWeight
//                                                     .bold,
//                                           ),
//                                         ),

//                                         IconButton(
//                                           onPressed:
//                                               () =>
//                                                   deleteAdvance(
//                                             advance,
//                                           ),
//                                           icon:
//                                               const Icon(
//                                             Icons
//                                                 .delete_outline,
//                                           ),
//                                           tooltip:
//                                               'કાઢી નાખો',
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),

//                             if (advances.isNotEmpty) ...[
//                               const Divider(
//                                 height: 24,
//                               ),

//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment
//                                         .spaceBetween,
//                                 children: [
//                                   const Text(
//                                     'કુલ એડવાન્સ',
//                                     style:
//                                         TextStyle(
//                                       fontSize: 16,
//                                       fontWeight:
//                                           FontWeight
//                                               .w600,
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹${totalAdvance.toStringAsFixed(2)}',
//                                     style:
//                                         const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight:
//                                           FontWeight
//                                               .bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 24),

//                 // ------------------------------------------------
//                 // SALARY PRINT
//                 // ------------------------------------------------

//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               SalaryPreviewScreen(
//                             worker: widget.worker,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.print),
//                     label: const Text(
//                       'પગાર પ્રિન્ટ કરો',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight:
//                             FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../controllers/worker_hours_controller.dart';
import '../../controllers/worker_advance_controller.dart';
import '../../models/worker.dart';
import 'salary_preview_screen.dart';
import '../../controllers/worker_controller.dart';
import 'edit_worker_screen.dart';

class WorkerDetailsScreen extends StatefulWidget {
  final Worker worker;

  const WorkerDetailsScreen({
    super.key,
    required this.worker,
  });

  @override
  State<WorkerDetailsScreen> createState() =>
      _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState
    extends State<WorkerDetailsScreen> {
  final WorkerHoursController workerHoursController =
      WorkerHoursController();

  final WorkerAdvanceController workerAdvanceController =
      WorkerAdvanceController();

  final TextEditingController hoursController =
      TextEditingController();

  final WorkerController workerController =
      WorkerController();

  bool isEditingToday = false;

  @override
  void initState() {
    super.initState();

    workerHoursController.loadWorkerHours(
      widget.worker.id!,
    );

    workerAdvanceController.loadAdvances(
      widget.worker.id!,
    );
  }

  @override
  void dispose() {
    hoursController.dispose();
    workerHoursController.dispose();
    workerAdvanceController.dispose();
    super.dispose();
  }

  Future<void> deleteWorker() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('કર્મચારી કાઢી નાખો?'),
          content: Text(
            '${widget.worker.name} ને કાઢી નાખવા માંગો છો?',
          ),
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
    final Worker? updatedWorker =
        await Navigator.of(context).push<Worker>(
      MaterialPageRoute(
        builder: (context) =>
            EditWorkerScreen(worker: widget.worker),
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

    final workerIndex =
        workerController.workers.indexWhere(
      (worker) => worker.id == widget.worker.id,
    );

    if (workerIndex == -1) {
      return;
    }

    await workerController.updateWorker(
      workerIndex,
      updatedWorker,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> saveHours() async {
    final hours =
        double.tryParse(hoursController.text.trim());

    if (hours == null || hours < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('યોગ્ય કલાક દાખલ કરો.'),
          ),
        );
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
      ..showSnackBar(
        const SnackBar(
          content: Text('આજના કલાક સેવ થઈ ગયા.'),
        ),
      );
  }

  void startEditToday() {
    final todayEntry =
        workerHoursController.todayHours;

    if (todayEntry == null) {
      return;
    }

    setState(() {
      isEditingToday = true;

      hoursController.text =
          todayEntry.hours.toString();
    });
  }

  Future<void> updateHours() async {
    final hours =
        double.tryParse(hoursController.text.trim());

    if (hours == null || hours < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('યોગ્ય કલાક દાખલ કરો.'),
          ),
        );
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
      ..showSnackBar(
        const SnackBar(
          content:
              Text('આજના કલાક અપડેટ થઈ ગયા.'),
        ),
      );
  }

  // ============================================================
  // ADD ADVANCE
  // ============================================================

  Future<void> addAdvance() async {
    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return const _AddAdvanceDialog();
      },
    );

    if (result == null) {
      return;
    }

    final reason =
        result['reason'] as String;

    final amount =
        result['amount'] as double;

    try {
      await workerAdvanceController.addAdvance(
        workerId: widget.worker.id!,
        reason: reason,
        amount: amount,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content:
                Text('એડવાન્સ સેવ થઈ ગયું.'),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'એડવાન્સ સેવ કરવામાં ભૂલ: $e',
            ),
          ),
        );
    }
  }

  // ============================================================
  // DELETE ADVANCE
  // ============================================================

  Future<void> deleteAdvance(int advanceId) async {
    try {
      await workerAdvanceController.deleteAdvance(
        advanceId,
        widget.worker.id!,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'એડવાન્સ કાઢવામાં ભૂલ: $e',
            ),
          ),
        );
    }
  }

  String formatDate(String date) {
    final parts = date.split('-');

    if (parts.length != 3) {
      return date;
    }

    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final worker = widget.worker;

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
                    Text(
                      'કર્મચારીમાં ફેરફાર કરો',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 10),
                    Text(
                      'કર્મચારી કાઢી નાખો',
                    ),
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
          // IMPORTANT:
          // Keep this INSIDE AnimatedBuilder.
          // This makes estimated salary update
          // after the worker hours are loaded/changed.
          final estimatedSalary =
              workerHoursController
                      .currentMonthTotalHours *
                  worker.hourlyRate;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  16,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                // =================================================
                // WORKER INFORMATION
                // =================================================

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'કલાક દીઠ દર: ₹${worker.hourlyRate.toStringAsFixed(2)}',
                          style:
                              const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =================================================
                // TODAY HOURS
                // =================================================

                if (!workerHoursController
                    .hasTodayEntry) ...[
                  const Text(
                    'આજના કામના કલાક',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        hoursController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction:
                        TextInputAction.done,
                    decoration:
                        const InputDecoration(
                      hintText:
                          'કલાક દાખલ કરો',
                      suffixText: 'કલાક',
                      border:
                          OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      saveHours();
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child:
                        ElevatedButton.icon(
                      onPressed: saveHours,
                      icon:
                          const Icon(Icons.save),
                      label: const Text(
                        'કલાક સેવ કરો',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else if (!isEditingToday)
                  Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'આજના કલાક',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${workerHoursController.todayHours!.hours.toStringAsFixed(2)} કલાક',
                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width:
                                double.infinity,
                            child:
                                OutlinedButton
                                    .icon(
                              onPressed:
                                  startEditToday,
                              icon:
                                  const Icon(
                                Icons.edit,
                              ),
                              label: const Text(
                                'આજના કલાક એડિટ કરો',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  const Text(
                    'આજના કલાક એડિટ કરો',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        hoursController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction:
                        TextInputAction.done,
                    decoration:
                        const InputDecoration(
                      suffixText: 'કલાક',
                      border:
                          OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      updateHours();
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          updateHours,
                      icon:
                          const Icon(Icons.save),
                      label: const Text(
                        'કલાક અપડેટ કરો',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // =================================================
                // MONTHLY SALARY
                // =================================================

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'આ મહિનાનો સારાંશ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'કુલ કામના કલાક',
                              style:
                                  TextStyle(
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              '${workerHoursController.currentMonthTotalHours.toStringAsFixed(2)} કલાક',
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'અંદાજિત પગાર',
                              style:
                                  TextStyle(
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              '₹${estimatedSalary.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =================================================
                // ADVANCE SECTION
                // =================================================

                AnimatedBuilder(
                  animation:
                      workerAdvanceController,
                  builder:
                      (context, child) {
                    final advances =
                        workerAdvanceController
                            .advances;

                    final totalAdvance =
                        workerAdvanceController
                            .totalAdvance;

                    return Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                const Text(
                                  'ઉધાર / એડવાન્સ',
                                  style:
                                      TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed:
                                      addAdvance,
                                  icon:
                                      const Icon(
                                    Icons
                                        .add_circle,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            if (advances.isEmpty)
                              const Padding(
                                padding:
                                    EdgeInsets
                                        .symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'હજુ કોઈ એડવાન્સ લીધું નથી.',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount:
                                    advances.length,
                                itemBuilder:
                                    (context, index) {
                                  final advance =
                                      advances[index];

                                  return ListTile(
                                    contentPadding:
                                        EdgeInsets.zero,

                                    title: Text(
                                      advance.reason,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),

                                    subtitle: Text(
                                      formatDate(
                                        advance.date,
                                      ),
                                    ),

                                    trailing: Row(
                                      mainAxisSize:
                                          MainAxisSize
                                              .min,
                                      children: [
                                        Text(
                                          '₹${advance.amount.toStringAsFixed(2)}',
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            deleteAdvance(
                                              advance.id!,
                                            );
                                          },
                                          icon:
                                              const Icon(
                                            Icons
                                                .delete_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                            if (advances.isNotEmpty) ...[
                              const Divider(),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  const Text(
                                    'કુલ એડવાન્સ',
                                    style:
                                        TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),

                                  Text(
                                    '₹${totalAdvance.toStringAsFixed(2)}',
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // =================================================
                // EXISTING SALARY PRINT BUTTON
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SalaryPreviewScreen(
                            worker:
                                widget.worker,
                          ),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.print),
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
      ),
    );
  }
}

// ================================================================
// ADD ADVANCE DIALOG
// ================================================================
//
// IMPORTANT:
// The TextEditingControllers belong to this dialog itself.
// Therefore Flutter removes the TextFields first and then
// dispose() removes the controllers safely.
// ================================================================

class _AddAdvanceDialog extends StatefulWidget {
  const _AddAdvanceDialog();

  @override
  State<_AddAdvanceDialog> createState() =>
      _AddAdvanceDialogState();
}

class _AddAdvanceDialogState
    extends State<_AddAdvanceDialog> {
  final TextEditingController reasonController =
      TextEditingController();

  final TextEditingController amountController =
      TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void save() {
    final reason =
        reasonController.text.trim();

    final amount =
        double.tryParse(
      amountController.text.trim(),
    );

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'શા માટે તે લખો.',
            ),
          ),
        );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'યોગ્ય રકમ દાખલ કરો.',
            ),
          ),
        );
      return;
    }

    Navigator.of(context).pop({
      'reason': reason,
      'amount': amount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'ઉધાર / એડવાન્સ ઉમેરો',
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: reasonController,
            textInputAction:
                TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'શા માટે?',
              hintText: 'જેમ કે Kaju 100 gm',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: amountController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction:
                TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'રકમ',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('રદ કરો'),
        ),

        ElevatedButton(
          onPressed: save,
          child: const Text('સેવ કરો'),
        ),
      ],
    );
  }
}