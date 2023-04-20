import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_repo.dart';
import 'package:yiwumart/util/function_class.dart';
part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionsRepository sessionsRepo;

  SessionsBloc(this.sessionsRepo) : super(SessionsInitial()) {
    on<LoadSessions>((event, emit) async {
      final sessions = await sessionsRepo.getSessions();
     if(state is! SessionsLoading) {
       emit(SessionsLoading(completer: event.completer));
     }
      emit(SessionsLoaded(sessions: sessions.data, currentSession: sessions.currentSession));
    });
    on<DestroySession>((event, emit) async {
      var resp = await sessionsRepo.destroySession(event.id);
      if(resp['success'] == true) {
        add(const LoadSessions());
      }
    });
    on<DestroyAllSessions>((event, emit) async {
      var passwordController = TextEditingController();
      var password = await showDialog(
        context: event.context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Введите пароль'),
            ),
            content: CupertinoTextField(
              controller: passwordController,
              obscureText: true,
              placeholder: 'Пароль',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Подтвердить'),
                onPressed: () {
                  Navigator.of(context).pop(passwordController.text);
                },
              ),
            ],
          );
        },
      );
      if (password != null) {
        var resp = await sessionsRepo.destroyAllSessions(pass: password);
        if(resp['success'] == true) {
          add(const LoadSessions());
          Func().showSnackbar(event.context, 'Все сессии успешно завершены', resp['success']);
        } else {
          Func().showSnackbar(event.context, resp['message'], resp['success']);
        }
      }
    });

  }
}
