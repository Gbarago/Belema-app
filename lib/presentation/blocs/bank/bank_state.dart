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

  // New fields to handle actions without losing data state
  final bool isLoading;
  final String? actionError;
  final String? actionSuccess;

  const BankDataLoaded({
    required this.account,
    required this.transactions,
    this.isLoading = false,
    this.actionError,
    this.actionSuccess,
  });

  BankDataLoaded copyWith({
    Account? account,
    List<Transaction>? transactions,
    bool? isLoading,
    String? actionError,
    String? actionSuccess, // Nullable to clear it
    bool clearError = false, // Helper to clear error
    bool clearSuccess = false, // Helper to clear success
  }) {
    return BankDataLoaded(
      account: account ?? this.account,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      actionError: clearError ? null : (actionError ?? this.actionError),
      actionSuccess: clearSuccess
          ? null
          : (actionSuccess ?? this.actionSuccess),
    );
  }

  @override
  List<Object?> get props => [
    account,
    transactions,
    isLoading,
    actionError,
    actionSuccess,
  ];
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
