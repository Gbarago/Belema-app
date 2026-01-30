import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:pointycastle/asymmetric/api.dart';

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
        print('DEBUG: getTransactions response: $data');
        final transactions = data
            .map((json) => TransactionModel.fromJson(json))
            .toList();

        // IGNORING BACKEND DATA (OR AUGMENTING IT) FOR DEMO/UI CHECK as requested
        if (transactions.isEmpty) {
          transactions.addAll([
            TransactionModel(
              id: 'd1',
              type: 'credit',
              amount: 150000.0,
              date: DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
              description: 'Salary Deposit',
            ),
            TransactionModel(
              id: 'd2',
              type: 'debit',
              amount: 1500.0,
              date: DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
              description: 'Netflix Subscription',
            ),
            TransactionModel(
              id: 'd3',
              type: 'debit',
              amount: 12500.0,
              date: DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String(),
              description: 'Groceries - Shoprite',
            ),
          ]);
        }

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
      // NOTE: Temporarily disabled encryption because the current backend
      // expects a 4-digit integer/string and cannot decrypt our payload.
      // In a real production environment with a paired backend, uncomment this:
      // final encryptedPin = _encryptPin(pin);

      final response = await apiClient.dio.post(
        'set-transaction-pin',
        data: {'pin': pin}, // Sending plain pin to ensure success
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
      // NOTE: Encryption disabled for backend compatibility.
      // final encryptedPin = _encryptPin(pin);

      final response = await apiClient.dio.post(
        'transfer',
        data: {
          'amount': amount,
          'destination_account_number': destinationAccount,
          'pin': pin, // Sending plain pin
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return const Left(ServerFailure('Transfer failed'));
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Transfer failed';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Implementation of encryption helper
  String _encryptPin(String pin) {
    // SECURITY NOTE:
    // In a production app, you would fetch a real RSA Public Key from the server
    // or secure storage. The 'encrypt' package and 'RSAKeyParser' would be used.
    //
    // Example Prod Implementation:
    // final parser = encrypt.RSAKeyParser();
    // final publicKey = parser.parse(serverPublicKeyPEM);
    // final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    // return encrypter.encrypt(pin).base64;

    // For this demonstration:
    // We are simulating the payload encryption using Base64
    // to avoid needing a valid RSA Key Pair to prevent runtime crashes.

    final bytes = utf8.encode(pin);
    final base64Pin = base64Encode(bytes);
    return 'ENC_$base64Pin';
  }
}
