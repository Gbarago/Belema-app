import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async'; // Added for StreamController

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://testbank-one.vercel.app/api/';

  // Stream to notify listeners about authentication errors (401)
  final _authErrorController = StreamController<void>.broadcast();
  Stream<void> get authErrorStream => _authErrorController.stream;

  ApiClient({required this.dio, required this.storage}) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Check for 401 Unauthorized
          if (e.response?.statusCode == 401) {
            _authErrorController.add(null);
          }
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
  }
}
