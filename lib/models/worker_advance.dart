class WorkerAdvance {
  final int? id;
  final int workerId;
  final String date;
  final String reason;
  final double amount;

  WorkerAdvance({
    this.id,
    required this.workerId,
    required this.date,
    required this.reason,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'worker_id': workerId,
      'date': date,
      'reason': reason,
      'amount': amount,
    };
  }

  factory WorkerAdvance.fromMap(Map<String, dynamic> map) {
    return WorkerAdvance(
      id: map['id'] as int?,
      workerId: map['worker_id'] as int,
      date: map['date'] as String,
      reason: map['reason'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }
}