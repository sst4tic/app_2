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

class ThemeChanged extends AuthState {
  final bool isDarkTheme;
  final bool isLightTheme;
  final bool isSystemTheme;

  ThemeChanged({
    required this.isDarkTheme,
    required this.isLightTheme,
    required this.isSystemTheme,
  });

  List<Object> get props => [isDarkTheme, isLightTheme, isSystemTheme];
}
