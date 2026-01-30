// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  accountNumber: json['accountNumber'] as String,
  accountName: json['accountName'] as String,
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'balance': instance.balance,
    };
