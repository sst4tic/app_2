part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String token;

  Authenticated({required this.token});
}

class Unauthenticated extends AuthState {
  final String token;

  Unauthenticated({required this.token});
}

