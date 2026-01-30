import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/bank_repository.dart';

class SetPinUseCase implements UseCase<void, String> {
  final BankRepository repository;

  SetPinUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String pin) async {
    return await repository.setTransactionPin(pin);
  }
}
