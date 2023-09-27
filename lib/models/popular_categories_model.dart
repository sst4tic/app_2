import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/util/styles.dart';
import '../catalog_screens/catalog_item.dart';
import '../util/popular_catalog.dart';

Widget buildPopularCategories(List<PopularCategories> categories) =>
    GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5.w / 5.h,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 5.h,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          final categoryItem = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CatalogItems(
                            id: categoryItem.id,
                            name: categoryItem.name,
                          )));
            },
            child: Container(
              padding: REdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).primaryColor,
                // color: Colors.red
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/test.png',
                    height: 35.h,
                    width: 55.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    categoryItem.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 9,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

//
