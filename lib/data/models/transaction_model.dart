import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.date,
    required super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);

    // Safely convert id to String
    if (modifiedJson['id'] != null) {
      modifiedJson['id'] = modifiedJson['id'].toString();
    } else {
      modifiedJson['id'] = 'trans_${DateTime.now().millisecondsSinceEpoch}';
    }

    // Handle required String fields
    if (modifiedJson['type'] == null) modifiedJson['type'] = 'unknown';
    if (modifiedJson['date'] == null)
      modifiedJson['date'] = DateTime.now().toString();
    if (modifiedJson['description'] == null)
      modifiedJson['description'] = 'No description';

    // Safely convert amount to double
    if (modifiedJson['amount'] != null) {
      if (modifiedJson['amount'] is int) {
        modifiedJson['amount'] = (modifiedJson['amount'] as int).toDouble();
      } else if (modifiedJson['amount'] is String) {
        modifiedJson['amount'] = double.tryParse(modifiedJson['amount']) ?? 0.0;
      }
    } else {
      modifiedJson['amount'] = 0.0;
    }

    return _$TransactionModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
