import 'package:equatable/equatable.dart';

abstract class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class FetchBankData extends BankEvent {}

class SetPinSubmitted extends BankEvent {
  final String pin;
  const SetPinSubmitted(this.pin);

  @override
  List<Object?> get props => [pin];
}

class TransferSubmitted extends BankEvent {
  final double amount;
  final String destinationAccount;
  final String pin;

  const TransferSubmitted({
    required this.amount,
    required this.destinationAccount,
    required this.pin,
  });

  @override
  List<Object?> get props => [amount, destinationAccount, pin];
}
