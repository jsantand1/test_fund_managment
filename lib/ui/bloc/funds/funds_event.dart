import 'package:equatable/equatable.dart';

abstract class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFundsState extends FundsEvent {
  const LoadFundsState();
}

class SubscribeToFund extends FundsEvent {
  final int fundId;
  final double amount;

  const SubscribeToFund({
    required this.fundId,
    required this.amount,
  });

  @override
  List<Object?> get props => [fundId, amount];
}

class UnsubscribeFromFund extends FundsEvent {
  final int fundId;

  const UnsubscribeFromFund({
    required this.fundId,
  });

  @override
  List<Object?> get props => [fundId];
}

class UpdateAvailableAmount extends FundsEvent {
  final double newAmount;

  const UpdateAvailableAmount({
    required this.newAmount,
  });

  @override
  List<Object?> get props => [newAmount];
}
