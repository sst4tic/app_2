part of 'bag_bloc.dart';

@immutable
abstract class BagEvent {}

class LoadBag extends BagEvent {
  LoadBag({
    this.completer,
  });

  final Completer? completer;

  List<Object?> get props => [completer];
}

class ChangeQuantity extends BagEvent {
  ChangeQuantity({
    required this.id,
    required this.quantity,
    required  this.context,
  });

  final int id;
  final int quantity;
  final BuildContext context;

  List<Object?> get props => [id, quantity, context];
}

class SelectItem extends BagEvent {
  SelectItem({
    required this.id,
    this.isSelectAll = false,
  });

  final int id;
  final bool isSelectAll;
  List<Object?> get props => [id];
}

class DeleteSelected extends BagEvent {
  DeleteSelected({
    required this.ids,
  });

  final Set<int> ids;

  List<Object?> get props => [ids];
}
