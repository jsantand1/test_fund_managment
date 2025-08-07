import 'package:equatable/equatable.dart';

abstract class FundsState extends Equatable {
  const FundsState();

  @override
  List<Object?> get props => [];
}

class FundsInitial extends FundsState {
  const FundsInitial();
}

class FundsLoaded extends FundsState {
  final double availableAmount;
  final Map<int, double> subscriptions; // fundId -> invested amount

  const FundsLoaded({
    required this.availableAmount,
    required this.subscriptions,
  });

  @override
  List<Object?> get props => [availableAmount, subscriptions];

  FundsLoaded copyWith({
    double? availableAmount,
    Map<int, double>? subscriptions,
  }) {
    return FundsLoaded(
      availableAmount: availableAmount ?? this.availableAmount,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  bool isSubscribed(int fundId) => subscriptions.containsKey(fundId);
  
  double? getInvestedAmount(int fundId) => subscriptions[fundId];
}
