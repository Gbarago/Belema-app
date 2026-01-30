import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/account.dart';
import '../entities/transaction.dart';

abstract class BankRepository {
  Future<Either<Failure, Account>> getAccountDetails();
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, void>> setTransactionPin(String pin);
  Future<Either<Failure, void>> transfer({
    required double amount,
    required String destinationAccount,
    required String pin,
  });
}
