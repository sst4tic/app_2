import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import 'abstract_bag.dart';
part 'bag_event.dart';
part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final AbstractBag bagRepo;
  BagBloc({required this.bagRepo}) : super(BagInitial()) {
    on<LoadBag>((event, emit) async {
      try {
        if (state is! BagLoading) {
          emit(BagLoading());
          final isAuthorized = Constants.USER_TOKEN.isNotEmpty;
          if (!isAuthorized) {
            emit(BagNotAuthorized());
          } else {
            final bagList = await bagRepo.getBagList();
            if(bagList.items.isNotEmpty){
              emit(BagLoaded(bagList: bagList));
            } else {
            emit(BagEmpty());
            }
          }
        }
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      } finally {
        event.completer?.complete();
      }
    });
  }
}