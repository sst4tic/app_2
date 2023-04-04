import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/bloc/bag_bloc/bag_repo.dart';
import 'package:yiwumart/models/bag_models/bag_state_models.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import '../bloc/bag_bloc/bag_bloc.dart';
import '../models/bag_models/build_bag.dart';

class ShoppingBag extends StatefulWidget {
  const ShoppingBag({
    Key? key,
  }) : super(key: key);

  @override
  State<ShoppingBag> createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  bool isUpdating = false;
  final _bagBloc = BagBloc(
    bagRepo: BagRepository(),
  );

  @override
  void initState() {
    super.initState();
    _bagBloc.add(LoadBag());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BagBloc>.value(
      value: _bagBloc,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Корзина',
            ),
            centerTitle: false,
          ),
          body: BlocBuilder<BagBloc, BagState>(
            bloc: _bagBloc,
            builder: (context, state) {
              if (state is BagLoading) {
                return buildBagShimmer(context);
              } else if (state is BagLoaded) {
                return const BagCartWidget();
              } else if (state is BagLoadingFailure) {
                return Text(state.exception.toString());
              } else if (state is BagEmpty) {
                return bagEmptyModel(context);
              } else if (state is BagNotAuthorized) {
                return bagNonAuthModel(context);
              } else {
                return const Text("No widget to build");
              }
            },
          )),
    );
  }
}
