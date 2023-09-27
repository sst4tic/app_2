import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiwumart/catalog_screens/catalog_item.dart';
import '../models/shimmer_model.dart';
import '../util/catalog.dart';
import 'package:http/http.dart' as http;
import '../util/constants.dart';

class ExpandableCategories extends StatefulWidget {
  const ExpandableCategories({Key? key, required this.name, required this.id})
      : super(key: key);
  final String? name;
  final int? id;

  @override
  State<ExpandableCategories> createState() => _ExpandableCategoriesState();
}

class _ExpandableCategoriesState extends State<ExpandableCategories> {
  static String? name;
  static int? id;

  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.name;
      id = widget.id;
    });
  }
  late Future<List<Catalog>> catalogFuture = getCatalog();

  static Future<List<Catalog>> getCatalog() async {
    var url = '${Constants.API_URL_DOMAIN_V3}categories/$id';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body['data'].map<Catalog>(Catalog.fromJson).toList();
  }

  static Future<List<Catalog>> getNestedCatalog(id) async {
    var url = '${Constants.API_URL_DOMAIN_V3}categories/$id}';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body['data'].map<Catalog>(Catalog.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text(name!,  style: Theme.of(context).textTheme.titleSmall),
        ),
        body: Column(
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondary,
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CatalogItems(
                                  id: id,
                                  name: name,
                                )));
                  },
                  title: const Text(
                    'Все товары из категории',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(height: 0,thickness: 1,),
              Expanded(
                child: FutureBuilder<List<Catalog>>(
                    future: catalogFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildExpandableShimmer();
                      } else if (snapshot.hasData) {
                        final catalog = snapshot.data!;
                        return buildExpandableCatalog(catalog);
                      } else {
                        return const Text("No widget to build");
                      }
                    }),
              )
            ],
          ),
        );
  }

  Widget buildExpandableCatalog(List<Catalog> catalog) => ListView.builder(
      itemCount: catalog.length,
      itemBuilder: (context, index) {
        final catalogItem = catalog[index];
        return Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: EdgeInsets.zero,
              elevation: 0,
              child: ExpansionTile(
                  onExpansionChanged: (a) {
                    if (catalogItem.hasChild != true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatalogItems(
                                    id: catalogItem.id,
                                    name: catalogItem.name,
                                  )));
                    }
                  },
                  trailing: catalogItem.hasChild
                      ? Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColorLight,)
                      : const Icon(null),
                  title: Text(
                    catalogItem.name,
                    style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColorLight),
                  ),
                  children: catalogItem.hasChild
                      ? <Widget>[
                          Column(
                              children: getNestedTitles(
                                  index, catalogItem.id, catalogItem.name))
                        ]
                      : []),
            ),
            const Divider(height: 0, thickness: 1,)
          ],
        );
      });

  List<Widget> getNestedTitles(int index, int id, String name) {
    List<Widget> list = [
     ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CatalogItems(
                          id: id,
                          name: name,
                        )));
          },
          title: const Text(
            'Все товары из категории',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
          ),
          leading: const Icon(null),
        ),
    ];
    getNestedCatalog(id).then((value) {
      for (var x in value) {
        list.add(
          Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 70),
                  child: Divider(height: 0, thickness: 1,)),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CatalogItems(
                            id: x.id,
                            name: x.name,
                          )));
                },
                title: Text(
                  x.name,
                  style: const TextStyle(fontSize: 13.0),
                ),
                leading: const Icon(null),
              ),
            ],
          ));
      }
    });
    return list;
  }
}
