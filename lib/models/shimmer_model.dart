import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../util/styles.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerWidget.rectangular({
    Key? key,
    this.width = double.infinity,
    required this.height,
  }) : super(key: key);

  const ShimmerWidget.circular({
    Key? key,
    this.width = double.infinity,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: MediaQuery.of(context).platformBrightness == Brightness.light
            ? ColorStyles.lightShimmerBaseColor
            : ColorStyles.darkShimmerBaseColor,
        highlightColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? ColorStyles.lightShimmerHighlightColor
                : ColorStyles.darkShimmerHighlightColor,
        period: const Duration(milliseconds: 800),
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
      );
}

Widget buildGridShimmer() => GridView.builder(
      shrinkWrap: true,
      gridDelegate: GridDelegateClass.gridDelegate,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: [
              ShimmerWidget.rectangular(height: 150.h),
              const Spacer(),
              Row(
                children: <Widget>[
                  ShimmerWidget.rectangular(
                    height: 20.h,
                    width: 80.w,
                  ),
                ],
              ),
              const Spacer(),
              ShimmerWidget.rectangular(
                height: 20.h,
                width: 400.w,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ShimmerWidget.rectangular(
                    height: 30.h,
                    width: 90.w,
                  ),
                  const Spacer(),
                  ShimmerWidget.rectangular(
                    height: 30.h,
                    width: 35.w,
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );

Widget buildSearchCatShimmer() => GridView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 45.w / 23.5.h,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 1.h),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            children: const [
              ShimmerWidget.rectangular(height: 150),
              SizedBox(
                height: 10,
              ),
              ShimmerWidget.rectangular(height: 17),
              SizedBox(
                height: 5,
              ),
              ShimmerWidget.rectangular(height: 13),
              SizedBox(
                height: 12,
              ),
              ShimmerWidget.rectangular(
                height: 25,
                width: 300,
              ),
            ],
          ),
        );
      },
    );

Widget buildSearchShimmer() => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: ShimmerWidget.rectangular(
                height: 15.h,
                width: 150.w,
              )),
          SizedBox(height: 300, child: buildSearchCatShimmer()),
          SizedBox(
            height: 5.h,
          ),
          Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ShimmerWidget.rectangular(height: 35.h)),
          Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: ShimmerWidget.rectangular(
                height: 20.h,
                width: 120.w,
              )),
          buildCatalogShimmer(physics: const NeverScrollableScrollPhysics()),
        ],
      ),
    );

Widget buildHorizontalShimmer() => ListView.builder(
    padding: const EdgeInsets.only(left: 10),
    scrollDirection: Axis.horizontal,
    itemCount: 5,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: 150,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: ShimmerWidget.rectangular(height: 30))
          ],
        ),
      );
    });

Widget buildCatalogShimmer({physics}) => ListView.builder(
    physics: physics,
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Container(
        padding: index == 0
            ? const EdgeInsets.only(top: 10, left: 10, right: 10)
            : const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: ListTile(
              title: ShimmerWidget.rectangular(height: 20),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ),
        ),
      );
    });

Widget buildNotificationsShimmer({physics}) => ListView.builder(
    physics: physics,
    shrinkWrap: true,
    itemCount: 10,
    padding: const EdgeInsets.all(8),
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                ShimmerWidget.rectangular(height: 20, width: 130),
                Spacer(),
                ShimmerWidget.rectangular(height: 20, width: 110),
              ],
            ),
            const ShimmerWidget.rectangular(height: 20, width: 100),
          ],
        ),
      );
    });

Widget buildExpandableShimmer() => ListView.builder(
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Column(children: [
        Card(
          color: Theme.of(context).colorScheme.secondary,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: ListTile(
              title: ShimmerWidget.rectangular(height: 20),
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1,
        )
      ]);
    });

Widget buildProfileShimmer() => ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.only(left: 5, right: 5),
          height: 80,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              width: 20,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerWidget.rectangular(
                    height: 15,
                    width: 100,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ShimmerWidget.rectangular(
                    height: 12,
                    width: 100,
                  ),
                ]),
          ]),
        );
      },
    );

Widget buildNewCatalogShimmer(context) => Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  width: 180,
                  height: 46.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: ShimmerWidget.rectangular(
                    height: 20,
                    width: 150,
                  ))),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                  width: 180,
                  height: 46.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: ShimmerWidget.rectangular(
                    height: 20,
                    width: 150,
                  ))),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: buildGridShimmer())
      ],
    );

Widget buildCartShimmer(context) => SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(
                height: MediaQuery.of(context).size.height * 0.4),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.all(10),
              height: 90.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(height: 20.h),
                  SizedBox(
                    height: 7.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 15.h,
                    width: 220,
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 20.h,
                    width: 100,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.all(10),
              height: 105.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    height: 22.h,
                    width: 150,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 20.h,
                        width: 130,
                      ),
                      const SizedBox(width: 70,),
                      ShimmerWidget.rectangular(
                        height: 20.h,
                        width: 100,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 20.h,
                        width: 100,
                      ),
                      const SizedBox(width: 100,),
                      ShimmerWidget.rectangular(
                        height: 20.h,
                        width: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: ShimmerWidget.rectangular(height: 33.h),
            ),
          ],
        ),
      ),
    );

Widget buildBagShimmer(context) => SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35.h,
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                title: const ShimmerWidget.rectangular(
                  height: 10,
                  width: 100,
                ),
                centerTitle: false,
              ),
            ),
            const Divider(height: 0, thickness: 1),
            buildBagCartShimmer(5),
            const Divider(height: 0, thickness: 1),
            SizedBox(
              height: 35.h,
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                actions: [
                  Container(
                    padding:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    height: 15.h,
                    child: const ShimmerWidget.rectangular(
                      height: 1,
                      width: 150,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: ShimmerWidget.rectangular(height: 35.h)),
          ],
        ),
      ),
    );

Widget buildBagCartShimmer(int count) => ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 80.h,
          color: Theme.of(context).colorScheme.secondary,
          child: Row(
            children: [
              ShimmerWidget.rectangular(
                height: 65.h,
                width: 65.h,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget.rectangular(
                      height: 15.h,
                      width: 200.w,
                    ),
                    SizedBox(height: 15.h),
                    ShimmerWidget.rectangular(
                      height: 15.h,
                      width: 80.w,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ShimmerWidget.rectangular(
                        height: 25.h,
                        width: 70.w,
                      ))),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 0,
          thickness: 1,
        );
      },
    );

Widget buildPurchaseHistoryShimmer(context) => Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
          padding: REdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                height: 75.h,
                child: Column(
                  children: [
                    Container(
                      height: 25.h,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Row(children: [
                        ShimmerWidget.rectangular(
                          height: 15.h,
                          width: 120.w,
                        ),
                        const Spacer(),
                        ShimmerWidget.rectangular(
                          height: 15.h,
                          width: 80.w,
                        ),
                      ]),
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    Container(
                      height: 30.h,
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(children: [
                        ShimmerWidget.rectangular(
                          height: 17.h,
                          width: 100.w,
                        ),
                        const Spacer(),
                        ShimmerWidget.rectangular(
                          height: 20.h,
                          width: 50.w,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }),
    );

Widget buildEditShimmer(context) => Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 45, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            height: 20.h,
            width: 50.w,
          ),
          SizedBox(height: 7.h),
          ShimmerWidget.rectangular(height: 25.h),
          SizedBox(height: 15.h),
          ShimmerWidget.rectangular(
            height: 20.h,
            width: 80.w,
          ),
          SizedBox(height: 7.h),
          ShimmerWidget.rectangular(height: 25.h),
          SizedBox(height: 15.h),
          ShimmerWidget.rectangular(
            height: 20.h,
            width: 120.w,
          ),
          SizedBox(height: 7.h),
          ShimmerWidget.rectangular(height: 25.h),
          SizedBox(height: 15.h),
          ShimmerWidget.rectangular(
            height: 20.h,
            width: 50.w,
          ),
          SizedBox(height: 7.h),
          ShimmerWidget.rectangular(height: 25.h),
          SizedBox(height: 15.h),
          ShimmerWidget.rectangular(
            height: 20.h,
            width: 120.w,
          ),
          SizedBox(height: 7.h),
          ShimmerWidget.rectangular(height: 25.h),
          SizedBox(height: 10.h),
          ShimmerWidget.rectangular(height: 35.h),
          SizedBox(height: 10.h),
          ShimmerWidget.rectangular(height: 35.h)
        ],
      ),
    );

Widget buildPurchaseShimmer(context) => Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: REdgeInsets.all(10),
      child: ListView(
        children: [
          SizedBox(
            height: 35.h,
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              title: const ShimmerWidget.rectangular(
                height: 15,
                width: 200,
              ),
              centerTitle: false,
            ),
          ),
          const Divider(height: 0, thickness: 1),
          Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: REdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(
                    height: 20,
                    width: 100,
                  ),
                  SizedBox(height: 10.h),
                  const ShimmerWidget.rectangular(height: 35),
                  SizedBox(height: 20.h),
                  const ShimmerWidget.rectangular(
                    height: 20,
                    width: 180,
                  ),
                  SizedBox(height: 10.h),
                  const ShimmerWidget.rectangular(height: 35),
                  SizedBox(height: 20.h),
                  const ShimmerWidget.rectangular(
                    height: 20,
                    width: 170,
                  ),
                  SizedBox(height: 10.h),
                  const ShimmerWidget.rectangular(height: 35),
                  SizedBox(height: 20.h),
                  const ShimmerWidget.rectangular(
                    height: 20,
                    width: 220,
                  ),
                  SizedBox(height: 10.h),
                  const ShimmerWidget.rectangular(height: 65),
                  SizedBox(height: 10.h),
                ],
              )),
          const Divider(height: 0, thickness: 1),
          Container(
            color: Theme.of(context).colorScheme.secondary,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget.rectangular(
                  height: 20,
                  width: 180,
                ),
                SizedBox(height: 5.h),
                const ShimmerWidget.rectangular(height: 35),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          SizedBox(
            height: 35.7.h,
            child: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                Container(
                  padding:
                      const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  height: 15.h,
                  child: ShimmerWidget.rectangular(
                    height: 1,
                    width: 200.w,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          SizedBox(
            height: 40.h,
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              title: ShimmerWidget.rectangular(
                height: 30.h,
              ),
            ),
          ),
        ],
      ),
    );

Widget buildDetailShimmer(context) => Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      child: ListView(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              height: 75.h,
              child: Column(
                children: [
                  Container(
                    height: 25.h,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Row(children: [
                      ShimmerWidget.rectangular(
                        height: 15.h,
                        width: 120.w,
                      ),
                      const Spacer(),
                      ShimmerWidget.rectangular(
                        height: 15.h,
                        width: 80.w,
                      ),
                    ]),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Container(
                    height: 30.h,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(children: [
                      ShimmerWidget.rectangular(
                        height: 17.h,
                        width: 100.w,
                      ),
                      const Spacer(),
                      ShimmerWidget.rectangular(
                        height: 20.h,
                        width: 50.w,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35.h,
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              title: const ShimmerWidget.rectangular(
                height: 20,
                width: 100,
              ),
              centerTitle: false,
            ),
          ),
          const Divider(height: 0, thickness: 1),
          buildBagCartShimmer(4),
          const Divider(height: 0, thickness: 1),
          SizedBox(
            height: 35.h,
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              actions: [
                Container(
                  padding:
                      const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  height: 15.h,
                  child: const ShimmerWidget.rectangular(
                    height: 1,
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
