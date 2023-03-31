import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/bloc/bag_bloc/bag_repo.dart';
import 'package:yiwumart/catalog_screens/purchase_screen.dart';
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

  void updateBagList() {
    setState(() {
      isUpdating = true;
      _bagBloc.add(LoadBag());
    });
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
                return bagLoadedModel(state);
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
          )
          ),
    );
  }
  Widget bagLoadedModel(state) {
   return Stack(
      children: [
        BagCartWidget(
          cart: state.bagList,
          qtyChangeCallback: updateBagList,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fixedSize: Size(1.sw, 5.h),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PurchaseScreen(
                            link: state.bagList.link,
                          )));
                },
                child: const Text(
                  'Оформить заказ',
                ),
              )),
        ),
      ],
    );
  }
}
