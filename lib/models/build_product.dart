import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../util/product_item.dart';
import 'image_list_model.dart';

Widget buildProduct({required ProductItem product, required context}) {
  final media = product.media!.map((e) => e.toJson()).toList();
  var mediaQuery = MediaQuery.of(context).size;
  return ListView(
    padding: REdgeInsets.only(bottom: 75),
    shrinkWrap: true,
    children: [
      SizedBox(
          height: mediaQuery.height * 0.4,
          child: ImageList(
            imageUrls: media.isNotEmpty
                ? media
                    .map((e) =>
                        'https://cdn.yiwumart.org/${e['links']['local']['thumbnails']['750']}')
                    .toList()
                : [
                    'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg'
                  ],
            fullImageUrl: media.isNotEmpty
                ? media
                    .map((e) =>
                        'https://cdn.yiwumart.org/${e['links']['local']['full']}')
                    .toList()
                : [
                    'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg'
                  ],
          )),
      Container(
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              product.categoryName!,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${product.price} ₸',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "О товаре",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "Артикул товара",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    product.sku,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "Наличие",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    product.availability,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: product.availability != 'Нет в наличии' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Описание",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              product.description != null
                  ? Html(data: product.description, shrinkWrap: true, style: {
                      'body': Style(
                          fontSize: FontSize(14.0),
                          color: Theme.of(context).primaryColorLight,
                        padding: EdgeInsets.zero,
                        margin: Margins.zero,
                      ),
                    })
                  : const Text(
                      'Описание отсутствует',
                      style: TextStyle(fontSize: 14.0),
                    ),
            ],
          )),
    ],
  );
}
