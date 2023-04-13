part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class LoadEditProfile extends EditProfileEvent {
 LoadEditProfile({this.completer});

 final Completer? completer;

  List<Object?> get props => [completer];
}

class SubmitEditProfile extends EditProfileEvent {
 SubmitEditProfile({
 required this.user,
  required this.context,
 });

  final User user;
  final BuildContext context;
  List<Object?> get props => [user, context];
}

class DeleteAccount extends EditProfileEvent {
  DeleteAccount({
   required this.context,
});

  final BuildContext context;
 List<Object?> get props => [context];
}