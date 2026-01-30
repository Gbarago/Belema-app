import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/account.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel extends Account {
  const AccountModel({
    required super.accountNumber,
    required super.accountName,
    required super.balance,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);

    // Safely convert accountNumber to String, provide default if null
    if (modifiedJson['accountNumber'] != null) {
      modifiedJson['accountNumber'] = modifiedJson['accountNumber'].toString();
    } else {
      modifiedJson['accountNumber'] = 'DATE-ERROR'; // Default or Placeholder
    }

    // Safely handle accountName
    if (modifiedJson['accountName'] != null) {
      modifiedJson['accountName'] = modifiedJson['accountName'].toString();
    } else {
      modifiedJson['accountName'] = 'Unknown Account';
    }

    // Safely convert balance to double
    if (modifiedJson['balance'] != null) {
      if (modifiedJson['balance'] is int) {
        modifiedJson['balance'] = (modifiedJson['balance'] as int).toDouble();
      } else if (modifiedJson['balance'] is String) {
        modifiedJson['balance'] =
            double.tryParse(modifiedJson['balance']) ?? 0.0;
      }
    } else {
      modifiedJson['balance'] = 0.0;
    }

    return _$AccountModelFromJson(modifiedJson);
  }

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
