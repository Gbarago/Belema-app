import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String type; // e.g., 'Credit', 'Debit'
  final double amount;
  final String date;
  final String description;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  @override
  List<Object?> get props => [id, type, amount, date, description];
}
