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
