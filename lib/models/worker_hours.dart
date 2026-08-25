class WorkerHours {
  final int? id;
  final int workerId;
  final String date;
  final double hours;

  WorkerHours({
    this.id,
    required this.workerId,
    required this.date,
    required this.hours,
  });
}