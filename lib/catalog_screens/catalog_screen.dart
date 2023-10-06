import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/util/catalog.dart';
import 'package:yiwumart/util/function_class.dart';
import '../models/search_model.dart';
import '../models/shimmer_model.dart';
import 'expandable_categories.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Catalog>> cacheCatalog;

  @override
  void initState() {
    cacheCatalog = Func().getCatalog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Каталог',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Padding(
            padding: REdgeInsets.only(
              left: 11,
              right: 11,
              bottom: 10,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onTap: () {
                  showSearch(context: context, delegate: SearchModel());
                },
              ),
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: cacheCatalog,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildCatalogShimmer();
            } else if (snapshot.hasData) {
              final catalog = snapshot.data!;
              return buildCatalog(catalog);
            } else {
              return const Text("No widget to build");
            }
          }),
    );
  }

  Widget buildCatalog(List<Catalog> catalog) => ListView.builder(
      itemCount: catalog.length,
      itemBuilder: (context, index) {
        final catalogItem = catalog[index];
        return Container(
          padding: index == 0
              ? const EdgeInsets.only(top: 10, left: 10, right: 10)
              : const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            child: ListTile(
              leading: Image.network(
                  catalogItem.image ?? 'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg',
              width: 55,
                height: 55,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpandableCategories(
                            name: catalogItem.name, id: catalogItem.id)));
              },
              title: Text(
                catalogItem.name,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ),
        );
      });
}
