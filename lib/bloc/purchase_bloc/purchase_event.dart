part of 'purchase_bloc.dart';

abstract class PurchaseEvent {}

class LoadPurchase extends PurchaseEvent {
  final int id;
  final String totalSum;
  final Completer? completer;

  LoadPurchase({required this.id, this.completer, required this.totalSum});
  List<Object?> get props => [id, completer, totalSum];
}

class PurchaseCheckout extends PurchaseEvent {
  final int cartId;
  final String address;
  final String phone;
  String? comments;
  final BuildContext context;

  PurchaseCheckout({required this.cartId, required this.address, required this.context, required this.phone, this.comments});
  List<Object?> get props => [cartId, address, context, phone, comments ?? ''];
}