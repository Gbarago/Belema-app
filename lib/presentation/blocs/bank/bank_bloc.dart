import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_account_details_usecase.dart';
import '../../../domain/usecases/get_transactions_usecase.dart';
import '../../../domain/usecases/set_pin_usecase.dart';
import '../../../domain/usecases/transfer_usecase.dart';
import 'bank_event.dart';
import 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final GetAccountDetailsUseCase getAccountDetailsUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final SetPinUseCase setPinUseCase;
  final TransferUseCase transferUseCase;

  BankBloc({
    required this.getAccountDetailsUseCase,
    required this.getTransactionsUseCase,
    required this.setPinUseCase,
    required this.transferUseCase,
  }) : super(BankInitial()) {
    on<FetchBankData>(_onFetchBankData);
    on<SetPinSubmitted>(_onSetPinSubmitted);
    on<TransferSubmitted>(_onTransferSubmitted);
  }

  Future<void> _onFetchBankData(
    FetchBankData event,
    Emitter<BankState> emit,
  ) async {
    emit(BankLoading());

    final accountResult = await getAccountDetailsUseCase(NoParams());
    final transactionsResult = await getTransactionsUseCase(NoParams());

    accountResult.fold((failure) => emit(BankError(failure.message)), (
      account,
    ) {
      transactionsResult.fold(
        (failure) => emit(BankError(failure.message)),
        (transactions) =>
            emit(BankDataLoaded(account: account, transactions: transactions)),
      );
    });
  }

  Future<void> _onSetPinSubmitted(
    SetPinSubmitted event,
    Emitter<BankState> emit,
  ) async {
    final currentState = state;
    if (currentState is BankDataLoaded) {
      emit(
        currentState.copyWith(
          isLoading: true,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } else {
      emit(BankLoading());
    }

    final result = await setPinUseCase(event.pin);

    result.fold(
      (failure) {
        if (currentState is BankDataLoaded) {
          emit(
            currentState.copyWith(
              isLoading: false,
              actionError: failure.message,
            ),
          );
        } else {
          emit(BankError(failure.message));
        }
      },
      (_) {
        if (currentState is BankDataLoaded) {
          emit(
            currentState.copyWith(
              isLoading: false,
              actionSuccess: 'PIN set successfully',
              clearError: true,
            ),
          );
          add(FetchBankData());
        } else {
          emit(const ActionSuccess('PIN set successfully'));
          add(FetchBankData());
        }
      },
    );
  }

  Future<void> _onTransferSubmitted(
    TransferSubmitted event,
    Emitter<BankState> emit,
  ) async {
    final currentState = state;
    if (currentState is BankDataLoaded) {
      emit(
        currentState.copyWith(
          isLoading: true,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } else {
      emit(BankLoading());
    }

    final result = await transferUseCase(
      TransferParams(
        amount: event.amount,
        destinationAccount: event.destinationAccount,
        pin: event.pin,
      ),
    );

    result.fold(
      (failure) {
        if (currentState is BankDataLoaded) {
          emit(
            currentState.copyWith(
              isLoading: false,
              actionError: failure.message,
            ),
          );
        } else {
          emit(BankError(failure.message));
        }
      },
      (_) {
        if (currentState is BankDataLoaded) {
          emit(
            currentState.copyWith(
              isLoading: false,
              actionSuccess: 'Transfer successful',
              clearError: true,
            ),
          );
          add(FetchBankData());
        } else {
          emit(const ActionSuccess('Transfer successful'));
          add(FetchBankData());
        }
      },
    );
  }
}
