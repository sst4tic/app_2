import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/screens/main_screen.dart';
import '../../util/function_class.dart';
import 'abstract_auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AbstractAuth authRepo;
  late StreamSubscription _authenticationStatusSubscription;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    authRepo.getCookie();
    authRepo.getFirebaseToken();
    _checkAuthenticationStatus();
    on<LoggedIn>((event, emit) {
      emit(Authenticated(token: event.token));
    });
    on<LogoutEvent>((event, emit) async {
      authRepo.logout();
      Func().logoutActions();
      scakey.currentState!.updateBadgeCount(0);
      emit(Unauthenticated(token: ''));
    });
    on<LoginSmsEvent>((event, emit) async {
      try {
        final response = await authRepo.loginSms(event.phone, event.context);
        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          Func().showSmsDialog(
              restartCallback: event.restartCallback,
              countStream: event.countStream,
              context: navKey.currentContext!,
              phone: event.phone,
              submitCallback: (val) async {
                final resp = await authRepo.checkSmsCode(event.phone, val);
                Func().showSnackbar(navKey.currentContext!,
                    resp.data['message'], resp.data['success']);
                if (resp.statusCode == 200) {
                  Navigator.pop(navKey.currentContext!);
                  print('API TOKEN:  ${resp.data['api_token']}');
                  emit(Authenticated(token: resp.data['api_token']));
                  Func().getInitParams();
                }
              });
        }
      } catch (e) {
        print(e);
      }
    });
    on<LoginEvent>((event, emit) async {
      final response =
          await authRepo.login(event.email, event.password, event.context);
      // ignore: use_build_context_synchronously
      Func().showSnackbar(
          event.context, response.data['message'], response.data['success']);
      if (response.data['success'] == true) {
        Func().getInitParams();
        emit(Authenticated(token: response.data['api_token']));
      } else {
        emit(Unauthenticated(token: ''));
      }
    });
    on<RegistrationEvent>((event, emit) async {
      final response = await authRepo.register(event.email, event.password,
          event.name, event.surname, event.context);
      Func().showSnackbar(
          event.context, response.data['message'], response.data['success']);
      if (response.data['success'] == true) {
        emit(Authenticated(token: response.data['api_token']));
        // ignore: use_build_context_synchronously
        Func().getInitParams();
        Future.delayed(const Duration(milliseconds: 250), () {
          Navigator.pop(event.context);
        });
      } else {
        emit(Unauthenticated(token: ''));
      }
    });
    on<ChangeThemeEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkTheme', event.isDarkTheme);
      prefs.setBool('isLightTheme', event.isLightTheme);
      prefs.setBool('isSystemTheme', event.isSystemTheme);
      emit(ThemeChanged(
          isDarkTheme: event.isDarkTheme,
          isLightTheme: event.isLightTheme,
          isSystemTheme: event.isSystemTheme));
    });
  }

  void _checkAuthenticationStatus() async {
    final isAuthenticated = await authRepo.getToken();
    final isAuth = await Func().getInitParams();
    if (isAuth.statusCode == 200) {
      add(LoggedIn(token: isAuthenticated));
    } else {
      add(LogoutEvent());
    }
    _authenticationStatusSubscription =
        Stream.periodic(const Duration(seconds: 30)).listen((_) async {
      final isAuthenticated = await authRepo.getToken();
      final isAuth = await Func().getInitParams();
      Func().getUnreadCount();
      if (isAuth.statusCode == 200) {
        add(LoggedIn(token: isAuthenticated));
      } else {
        add(LogoutEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      final isAuthenticated = await authRepo.getToken();
      if (isAuthenticated != '') {
        yield Authenticated(token: isAuthenticated.toString());
      } else {
        yield Unauthenticated(token: isAuthenticated.toString());
      }
    } else if (event is LoggedIn) {
      yield Authenticated(token: event.token);
    } else if (event is LogoutEvent) {
      yield Unauthenticated(token: '');
    } else if (event is LoginEvent) {
      final data =
          await authRepo.login(event.email, event.password, event.context);
      if (data['api_token'] != '') {
        yield Authenticated(token: data['api_token']);
      } else {
        yield Unauthenticated(token: 'token');
      }
    } else if (event is ChangeThemeEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkTheme', event.isDarkTheme);
      prefs.setBool('isLightTheme', event.isLightTheme);
      prefs.setBool('isSystemTheme', event.isSystemTheme);
      yield ThemeChanged(
          isDarkTheme: event.isDarkTheme,
          isLightTheme: event.isLightTheme,
          isSystemTheme: event.isSystemTheme);
    }
  }
}
