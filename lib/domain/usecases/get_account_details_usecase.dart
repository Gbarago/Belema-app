import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/account.dart';
import '../repositories/bank_repository.dart';

class GetAccountDetailsUseCase implements UseCase<Account, NoParams> {
  final BankRepository repository;

  GetAccountDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Account>> call(NoParams params) async {
    return await repository.getAccountDetails();
  }
}
