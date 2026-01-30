import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/bank_repository.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';

class BankRepositoryImpl implements BankRepository {
  final ApiClient apiClient;

  BankRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, Account>> getAccountDetails() async {
    try {
      final response = await apiClient.dio.get('get-account-details');
      if (response.statusCode == 200) {
        return Right(AccountModel.fromJson(response.data));
      } else {
        return const Left(ServerFailure('Failed to fetch account details'));
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final response = await apiClient.dio.get('get-transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('DEBUG: getTransactions response: $data'); // Debug print
        final transactions = data
            .map((json) => TransactionModel.fromJson(json))
            .toList();
        return Right(transactions);
      } else {
        return const Left(ServerFailure('Failed to fetch transactions'));
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTransactionPin(String pin) async {
    try {
      final response = await apiClient.dio.post(
        'set-transaction-pin',
        data: {'pin': pin},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return const Left(ServerFailure('Failed to set PIN'));
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> transfer({
    required double amount,
    required String destinationAccount,
    required String pin,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'transfer',
        data: {
          'amount': amount,
          'destination_account_number': destinationAccount,
          'pin': pin,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return const Left(ServerFailure('Transfer failed'));
      }
    } on DioException catch (e) {
      // Check if it's a validation error or insufficient funds
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Transfer failed';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
