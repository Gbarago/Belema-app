import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({required this.apiClient, required this.storage});

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final response = await apiClient.dio.post(
        'login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userModel = UserModel.fromJson(response.data);
        if (userModel.token != null) {
          await storage.write(key: 'auth_token', value: userModel.token);
        }
        return Right(userModel);
      } else {
        return const Left(AuthFailure('Invalid credentials'));
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Server Error';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await storage.delete(key: 'auth_token');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await storage.read(key: 'auth_token');
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
