import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String accountNumber;
  final String accountName;
  final double balance;

  const Account({
    required this.accountNumber,
    required this.accountName,
    required this.balance,
  });

  @override
  List<Object?> get props => [accountNumber, accountName, balance];
}
