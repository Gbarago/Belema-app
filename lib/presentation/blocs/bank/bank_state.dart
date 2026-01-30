import 'package:equatable/equatable.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/transaction.dart';

abstract class BankState extends Equatable {
  const BankState();

  @override
  List<Object?> get props => [];
}

class BankInitial extends BankState {}

class BankLoading extends BankState {}

class BankDataLoaded extends BankState {
  final Account account;
  final List<Transaction> transactions;

  const BankDataLoaded({required this.account, required this.transactions});

  @override
  List<Object?> get props => [account, transactions];
}

class ActionSuccess extends BankState {
  final String message;
  const ActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BankError extends BankState {
  final String message;
  const BankError(this.message);

  @override
  List<Object?> get props => [message];
}
