import 'package:flutter/material.dart';
import '../catalog_screens/catalog_item.dart';
import '../util/popular_catalog.dart';

Widget buildPopularCategories(List<PopularCategories> categories) => ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: categories.length,
  padding: EdgeInsets.zero,
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
        margin: index == categories.length - 1
            ? const EdgeInsets.only(right: 0)
            : const EdgeInsets.only(right: 7),
        width: 150,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: NetworkImage(categoryItem.image),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatalogItems(
                                  id: categoryItem.id,
                                  name: categoryItem.name,
                                )));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(43, 46, 74, 0.8)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Text(
                          categoryItem.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  },
);