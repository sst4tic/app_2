part of 'purchase_bloc.dart';

@immutable
abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {
  final Completer? completer;

  PurchaseLoading({this.completer});
  List<Object?> get props => [completer];
}

class PurchaseLoaded extends PurchaseState {
  final int id;
  final User user;
  final String totalSum;

  PurchaseLoaded({required this.id, required this.user, required this.totalSum});
  List<Object?> get props => [id, user, totalSum];
}

class PurchaseError extends PurchaseState {
  final Object? error;

  PurchaseError({required this.error});
  List<Object?> get props => [error];
}