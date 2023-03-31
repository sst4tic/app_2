part of 'bag_bloc.dart';

@immutable
abstract class BagState {}

class BagInitial extends BagState {
  List<Object?> get props => [];
}

class BagLoading extends BagState{
  BagLoading({
    this.completer,
  });

  final Completer? completer;

  List<Object?> get props => [completer];
}

class BagLoaded extends BagState{
  BagLoaded({
    required this.bagList,
  });

  final CartItem bagList;

  List<Object?> get props => [bagList];
}

class BagEmpty extends BagState{
  List<Object?> get props => [];
}

class BagNotAuthorized extends BagState{
  List<Object?> get props {
    if (Constants.USER_TOKEN.isNotEmpty) {
      return [true];
    } else {
      return [false];
    }
  }
}
class BagLoadingFailure extends BagState{
  BagLoadingFailure({
    this.exception,
  });

  final Object? exception;

  List<Object?> get props => [exception];
}