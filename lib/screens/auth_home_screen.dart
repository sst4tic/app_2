import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/models/gridview_model.dart';
import 'package:yiwumart/models/posts_model.dart';
import 'package:yiwumart/models/search_model.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/main_screen.dart';
import 'package:yiwumart/screens/notification_screen.dart';
import 'package:yiwumart/util/popular_catalog.dart';
import '../bloc/home_page_bloc/home_page_bloc.dart';
import '../models/popular_categories_model.dart';
import '../util/product.dart';
import '../util/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHomePage extends StatefulWidget {
  const AuthHomePage({Key? key}) : super(key: key);

  @override
  State<AuthHomePage> createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  TextEditingController searchController = TextEditingController();
  final _homePageBloc = HomePageBloc();
  final int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _homePageBloc.add(LoadHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomePageBloc(),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          bloc: _homePageBloc,
          builder: (context, state) {
            if (state is HomePageLoading) {
              return Scaffold(
                body: buildShimmer(),
              );
            } else if (state is HomePageLoaded) {
              final categories = state.popularCategories;
              final products = state.productsOfDay;
              return buildHomePage(categories: categories, products: products, posts: state.posts);
            } else if (state is HomePageError) {
              return Scaffold(
                body: Center(
                  child: Text(state.e.toString()),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Error'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildHomePage(
          {required List<PopularCategories> categories,
            required List<PostsModel> posts,
          required List<Product> products}) =>
      CustomScrollView(
        slivers: [
          SliverAppBar(
              elevation: 0,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/img/logo.svg',
                width: 86,
                height: 23.59,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.h),
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()),
                          );
                        },
                        icon: const Icon(Icons.notifications),
                      ),
                      if (_unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              _unreadCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              bottom: AppBar(
                titleSpacing: 10,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(
                    // top: 10,
                    bottom: 12,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.all(8),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onTap: () {
                        showSearch(context: context, delegate: SearchModel());
                      },
                    ),
                  ),
                ),
              )),
          SliverPadding(
            padding: REdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 99,
                          child: ListView.builder(
                              itemCount: posts.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return Stack(
                                  children: [
                                    Container(
                                        margin: REdgeInsets.only(
                                            right: 18,
                                            bottom: 2.5,
                                            top: 2.5,
                                            left: 2.5),
                                        padding: REdgeInsets.all(4),
                                        width: 92,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(post.image),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 2.50,
                                              strokeAlign:
                                                  BorderSide.strokeAlignOutside,
                                              color: Color(0xFF2C2D4F),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        )),
                                    Container(
                                      width: 95,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: const Alignment(0.00, 1.00),
                                          end: const Alignment(0, -1),
                                          colors: [
                                            Colors.black,
                                            Colors.black.withOpacity(0)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 2,
                                      right: 0,
                                      bottom: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
                                        child: Text(
                                          // make text limit to 28 characters
                                          post.content.length > 40
                                              ? post.content.substring(0, 28) +
                                                  '...'
                                              : post.content,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: 'Noto Sans',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Популярные категории',
                                style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontSize: 16,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w500,
                                )),
                            GestureDetector(
                              onTap: () => scakey.currentState!.onItemTapped(1),
                              child: const Text('Все',
                                  style: TextStyle(
                                    color: Color(0xFF2C2D4F),
                                    fontSize: 15,
                                    fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                            height: 165,
                            child: buildPopularCategories(categories)),
                        // Container(
                        //   height: 160,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: categories.length,
                        //     itemBuilder: (context, index) {
                        //       final category = categories[index];
                        //       return GestureDetector(
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //     context,
                        //           //     MaterialPageRoute(
                        //           //         builder: (context) => CatalogItems(
                        //           //               id: category.id,
                        //           //               name: category.name,
                        //           //             )));
                        //         },
                        //         child: SizedBox(
                        //           width: 120,
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Image.network(
                        //                 category.image,
                        //                 height: 30,
                        //                 width: 30,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //               SizedBox(height: 5.h),
                        //               Text(
                        //                 category.name,
                        //                 textAlign: TextAlign.center,
                        //                 maxLines: 2,
                        //                 overflow: TextOverflow.ellipsis,
                        //                 style: const TextStyle(
                        //                   color: Color(0xFF181C32),
                        //                   fontSize: 9,
                        //                   fontFamily: 'Noto Sans',
                        //                   fontWeight: FontWeight.w500,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                        const Text('Товары дня',
                            style: TextStyle(
                              color: Color(0xFF494949),
                              fontSize: 16,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 12),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: SingleChildScrollView(
                              child: BuildGridWidget(products: products)),
                        )
                      ]),
                ],
              ),
            ),
          )
        ],
      );

  Widget buildShimmer() => CustomScrollView(
        slivers: [
          SliverAppBar(
              elevation: 0,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/img/logo.svg',
                height: 15.h,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.h),
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()),
                          );
                        },
                        icon: const Icon(CupertinoIcons.bell_fill),
                      ),
                    ],
                  ),
                ),
              ],
              bottom: AppBar(
                titleSpacing: 10,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.all(8),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onTap: () {
                        showSearch(context: context, delegate: SearchModel());
                      },
                    ),
                  ),
                ),
              )),
          SliverPadding(
            padding: REdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('Популярные категории',
                            style: TextStyles.headerStyle),
                        const SizedBox(height: 10),
                        SizedBox(height: 241, child: buildHorizontalShimmer()),
                        const SizedBox(height: 15),
                        Text('Товары дня', style: TextStyles.headerStyle),
                        const SizedBox(height: 15),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child:
                              SingleChildScrollView(child: buildGridShimmer()),
                        )
                      ]),
                ],
              ),
            ),
          )
        ],
      );
}
