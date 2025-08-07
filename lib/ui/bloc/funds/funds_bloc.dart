import 'package:flutter_bloc/flutter_bloc.dart';
import 'funds_event.dart';
import 'funds_state.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  FundsBloc() : super(const FundsInitial()) {
    on<LoadFundsState>(_onLoadFundsState);
    on<SubscribeToFund>(_onSubscribeToFund);
    on<UnsubscribeFromFund>(_onUnsubscribeFromFund);
    on<UpdateAvailableAmount>(_onUpdateAvailableAmount);
  }

  void _onLoadFundsState(
    LoadFundsState event,
    Emitter<FundsState> emit,
  ) {
    // Si ya tenemos un estado cargado, no lo sobrescribimos
    if (state is FundsLoaded) {
      return;
    }

    // Inicializar con monto disponible por defecto
    emit(const FundsLoaded(
      availableAmount: 500000, // Monto inicial por defecto
      subscriptions: {},
    ));
  }

  void _onSubscribeToFund(
    SubscribeToFund event,
    Emitter<FundsState> emit,
  ) {
    final currentState = state;
    if (currentState is FundsLoaded) {
      // Verificar que hay fondos suficientes
      if (event.amount > currentState.availableAmount) {
        return; // No hacer nada si no hay fondos suficientes
      }

      final updatedSubscriptions = Map<int, double>.from(currentState.subscriptions);
      updatedSubscriptions[event.fundId] = event.amount;

      emit(currentState.copyWith(
        availableAmount: currentState.availableAmount - event.amount,
        subscriptions: updatedSubscriptions,
      ));
    }
  }

  void _onUnsubscribeFromFund(
    UnsubscribeFromFund event,
    Emitter<FundsState> emit,
  ) {
    final currentState = state;
    if (currentState is FundsLoaded) {
      final investedAmount = currentState.subscriptions[event.fundId];
      if (investedAmount != null) {
        final updatedSubscriptions = Map<int, double>.from(currentState.subscriptions);
        updatedSubscriptions.remove(event.fundId);

        emit(currentState.copyWith(
          availableAmount: currentState.availableAmount + investedAmount,
          subscriptions: updatedSubscriptions,
        ));
      }
    }
  }

  void _onUpdateAvailableAmount(
    UpdateAvailableAmount event,
    Emitter<FundsState> emit,
  ) {
    final currentState = state;
    if (currentState is FundsLoaded) {
      emit(currentState.copyWith(
        availableAmount: event.newAmount,
      ));
    }
  }
}
