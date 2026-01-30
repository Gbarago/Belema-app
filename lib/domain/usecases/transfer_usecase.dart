import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/bank_repository.dart';

class TransferUseCase implements UseCase<void, TransferParams> {
  final BankRepository repository;

  TransferUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(TransferParams params) async {
    return await repository.transfer(
      amount: params.amount,
      destinationAccount: params.destinationAccount,
      pin: params.pin,
    );
  }
}

class TransferParams {
  final double amount;
  final String destinationAccount;
  final String pin;

  TransferParams({
    required this.amount,
    required this.destinationAccount,
    required this.pin,
  });
}
