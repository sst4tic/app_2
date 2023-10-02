part of 'bag_bloc.dart';

@immutable
abstract class BagState {}

class BagInitial extends BagState {
  List<Object?> get props => [];
}

class BagLoading extends BagState {
  BagLoading({
    this.completer,
  });

  final Completer? completer;

  List<Object?> get props => [completer];
}

class BagLoaded extends BagState {
  BagLoaded({
    required this.cart,
    required this.selectedItems,
    required this.allSelected,
  });

  final CartItem cart;
  final Set<int> selectedItems;
  bool allSelected;

  List<Object?> get props => [cart];
}

class BagEmpty extends BagState {
  BagEmpty({
    required this.products,
  });

  List<Object?> get props => [];
  final List<Product> products;
}

class BagNotAuthorized extends BagState {
  List<Object?> get props {
    if (Constants.USER_TOKEN.isNotEmpty) {
      return [true];
    } else {
      return [false];
    }
  }
}

class BagLoadingFailure extends BagState {
  BagLoadingFailure({
    this.exception,
  });

  final Object? exception;

  List<Object?> get props => [exception];
}
