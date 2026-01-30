import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/bank_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/bank_repository.dart';
import 'domain/usecases/get_account_details_usecase.dart';
import 'domain/usecases/get_transactions_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/get_token_usecase.dart';
import 'domain/usecases/set_pin_usecase.dart';
import 'domain/usecases/transfer_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/bank/bank_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getTokenUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl(), storage: sl()),
  );

  //! Features - Bank
  // Bloc
  sl.registerFactory(
    () => BankBloc(
      getAccountDetailsUseCase: sl(),
      getTransactionsUseCase: sl(),
      setPinUseCase: sl(),
      transferUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAccountDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => SetPinUseCase(sl()));
  sl.registerLazySingleton(() => TransferUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BankRepository>(
    () => BankRepositoryImpl(apiClient: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => ApiClient(dio: sl(), storage: sl()));

  //! External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
