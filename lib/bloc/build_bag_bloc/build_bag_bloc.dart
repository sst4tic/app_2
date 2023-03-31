import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'build_bag_event.dart';
part 'build_bag_state.dart';

class BuildBagBloc extends Bloc<BuildBagEvent, BuildBagState> {
  BuildBagBloc() : super(BuildBagInitial()) {
    on<BuildBagEvent>((event, emit) {
    });
  }
}
