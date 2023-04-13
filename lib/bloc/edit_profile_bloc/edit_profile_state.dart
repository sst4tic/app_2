part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {
  List<Object?> get props => [];
}

class EditProfileLoading extends EditProfileState {
  EditProfileLoading({this.completer});

  final Completer? completer;
  List<Object?> get props => [completer];
}

class EditProfileLoaded extends EditProfileState {
  EditProfileLoaded({required this.user});

  final User user;
  List<Object?> get props => [user];
}

class EditProfileError extends EditProfileState {
  EditProfileError({required this.error});

  final Object? error;
  List<Object?> get props => [error];
}