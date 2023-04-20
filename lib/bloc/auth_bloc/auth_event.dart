part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;

  LoggedIn({required this.token});
}

class LogoutEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password, required this.context});

  List<Object> get props => [email, password, context];
}

class RegistrationEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String name;
  final String surname;

  RegistrationEvent(
      {required this.email,
      required this.password,
      required this.name,
      required this.surname,
      required this.context});

  List<Object> get props => [email, password, name, surname, context];
}
