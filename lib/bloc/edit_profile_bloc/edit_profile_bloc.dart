import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/user.dart';
import 'abstract_edit.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AbstractEdit editProfileRepo;
  EditProfileBloc({required this.editProfileRepo})
      : super(EditProfileLoading()) {
    on<LoadEditProfile>((event, emit) async {
      try {
        emit(EditProfileLoading());
        var user = await editProfileRepo.getProfile();
        emit(EditProfileLoaded(user: user));
      } catch (e) {
        emit(EditProfileError(error: e));
      } finally {
        event.completer?.complete();
      }
    });

    on<SubmitEditProfile>((event, emit) async {
      try {
       var resp = await editProfileRepo.editProfile(event.user);
        // ignore: use_build_context_synchronously
        showCupertinoDialog(context: event.context,
            builder: (context) =>
                CupertinoAlertDialog(title: Text(resp['success'] ? 'Успешно' : 'Произошла ошибка!'),
                  content: Text(resp['success'] ? 'Данные успешно обновлены' : 'Повторите попытку позже'),
                  actions: [
                    CupertinoDialogAction(child: const Text('Продолжить'),
                        onPressed: () => Navigator.pop(context))
                  ],));
            } catch (e)
        {
          print(e);
          emit(EditProfileError(error: e));
        }
      });
    }
  }
