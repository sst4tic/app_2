import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/models/gridview_model.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/util/function_class.dart';
import 'package:yiwumart/util/product.dart';
import 'package:http/http.dart' as http;
import '../models/filter_sliverlist.dart';
import '../util/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CatalogItems extends StatefulWidget {
  const CatalogItems({Key? key, required this.id, required this.name})
      : super(key: key);
  final int? id;
  final String? name;

  @override
  State<CatalogItems> createState() => _CatalogItemsState();
}

const List<String> orderByList = <String>['price_asc', 'price_desc'];
const orderByMap = {
  'price_asc': 'Цена по возрастанию',
  'price_desc': 'Цена по убыванию',
};

class _CatalogItemsState extends State<CatalogItems> {
  static int? id;
  static String? name;
  var val;
  var filters;
  var filterValues = {};
  var filterDefaultValues = {};
  int selectedIndex = -1;
  List<Product> list = [];
  ScrollController sController = ScrollController();
  int page = 1;
  bool hasMore = true;
  double _startValue = 0.0;
  double _endValue = 0.0;
  double? minValue = 0.0;
  double? maxValue = 0.0;
  final startController = TextEditingController();
  final endController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  late final filterUrl =
      'https://yiwumart.org/api/v1/core?action=filters_list&category_id=$id';
  var filterData;

  _setStartValue() {
    double? start = double.tryParse(startController.text);
    double? end = double.tryParse(endController.text);
    if (start != null &&
        end != null &&
        start <= end &&
        start >= minValue! &&
        end >= minValue! &&
        start <= maxValue! &&
        end <= maxValue!) {
      setState(() {
        _startValue = start.roundToDouble();
      });
    }
  }

  _setEndValue() {
    double? start = double.tryParse(startController.text);
    double? end = double.tryParse(endController.text);
    if (start != null &&
        end != null &&
        start <= end &&
        start >= minValue! &&
        end >= minValue! &&
        start <= maxValue! &&
        end <= maxValue!) {
      setState(() {
        _endValue = end.roundToDouble();
      });
    }
  }

  late Future<List<Product>> productFuture = getProducts();

  Future<List<Product>> getProducts([orderby = '', filter = '']) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=catalog&category_id=$id&page=$page&orderby=$orderby&$filter';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        if (List.from(body['data'].map((e) => Product.fromJson(e)).toList())
            .isNotEmpty) {
          page++;
        }
        if (List.from(body['data'].map((e) => Product.fromJson(e)).toList())
            .isEmpty) {
          hasMore = false;
        }
        list.addAll(
            List.from(body['data'].map((e) => Product.fromJson(e)).toList()));
      });
    }
    return list;
  }

  Future<void> fetchFilterData() async {
    final response = await http.get(Uri.parse(filterUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      setState(() {
        filterData = body['data'];
        if (filterData['price']['min'] != null ||
            filterData['price']['min'] != null) {
          if (filterValues.containsKey('start_value')) {
            minValue = double.parse(
                filterData['price']['min'].roundToDouble().toString());
            _startValue = double.parse(filterValues['start_value']).toDouble();
          } else {
            minValue = double.parse(
                filterData['price']['min'].roundToDouble().toString());
            _startValue = minValue!;
          }
          if (filterValues.containsKey('end_value')) {
            maxValue = double.parse(
                filterData['price']['max'].roundToDouble().toString());
            _endValue = double.parse(filterValues['end_value']).toDouble();
          } else {
            maxValue = double.parse(
                filterData['price']['max'].roundToDouble().toString());
            _endValue = maxValue!;
          }
          startController.text = _startValue.round().toString();
          endController.text = _endValue.round().toString();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startController.addListener(_setStartValue);
    endController.addListener(_setEndValue);
    sController.addListener(() {
      if (sController.position.maxScrollExtent == sController.offset) {
        if (hasMore) {
          getProducts(val, filters);
        }
      }
    });
    name = widget.name;
    id = widget.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFilterData();
  }

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    endController.dispose();
    sController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name!),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Product>>(
                  future: productFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildNewCatalogShimmer(context);
                    } else if (snapshot.hasData) {
                      final catalog = snapshot.data;
                      if (catalog!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Нет товаров',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return buildCatalog(catalog);
                    } else {
                      return const Text("No widget to build");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCatalog(List<Product> product) => CustomScrollView(
        controller: sController,
        slivers: [
          Func.sizedGrid,
          FilterSliverList(
            onSortChanged: showSort,
            // onSortChanged: (value) {
            //   setState(() {
            //     val = value.toString();
            //     page = 1;
            //     list.clear();
            //     productFuture = getProducts(value.toString(), filters);
            //   });
            // },
            onFilterClick: () => showFilter(context),
            val: val,
          ),
          Func.sizedGrid,
          SliverToBoxAdapter(
            child: BuildGridWidget(
              products: product,
            ),
          ),
          Func.sizedGrid,
          Func.sizedGrid,
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.04),
                    child: Center(
                        child: product.length >= 6 && hasMore
                            ? const CircularProgressIndicator()
                            : const Text('Больше данных нет')));
              },
              childCount: 1,
            ),
          )
        ],
      );

  //////////////////////////////////////////////////////////////////////////////////////////////////

  void showSort() => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      builder: (c) {
        return Container(
          height: 200.h,
          padding: REdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 6,
                width: 120.w,
              ),
              // create 3 radio with 3 text
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderByList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: val == orderByList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          val = value! ? orderByList[index] : null;
                          page = 1;
                          list.clear();
                          productFuture = getProducts(val.toString(), filters);
                        });
                        Navigator.pop(context);
                      },
                      checkColor: Colors.white,
                      activeColor: const Color(0xFF0D6EFD),
                      checkboxShape: const CircleBorder(
                        side: BorderSide(
                            width: 1,
                            color: Color(0xFFC7C7C7),
                            strokeAlign: BorderSide.strokeAlignOutside),
                      ),
                      title: Text(
                        orderByMap[orderByList[index]]!,
                        style: const TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 18,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });

  Future showFilter(context) => showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) => StatefulBuilder(builder: (context, innerSetState) {
            return SafeArea(
              child: FormBuilder(
                key: _formKey,
                child: Container(
                    color: Theme.of(context).primaryColor,
                    height: MediaQuery.of(context).size.height * 0.65,
                    padding: REdgeInsets.all(8),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 30,
                            ),
                          ),
                          const Text(
                            'Фильтр',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _formKey.currentState?.reset();
                                  _startValue = minValue!;
                                  _endValue = maxValue!;
                                  startController.text =
                                      _startValue.round().toString();
                                  endController.text =
                                      _endValue.round().toString();
                                  filterDefaultValues.forEach((key, value) {
                                    if (_formKey.currentState!.fields
                                        .containsKey(key)) {
                                      _formKey.currentState?.fields[key]!
                                          .didChange(value);
                                    }
                                  });
                                });
                              },
                              child: Text(
                                'Сброс',
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.47,
                        child: ListView(
                          children: [
                            filterData['price']['min'] != null
                                ? Padding(
                                    padding: REdgeInsets.only(left: 8),
                                    child: const Text(
                                      'Цена',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : Container(),
                            filterData['price']['min'] != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            child: FormBuilderTextField(
                                              name: 'start_value',
                                              onChanged: (value) {
                                                innerSetState(() {
                                                  if (value == '' ||
                                                      value == '0') {
                                                    _startValue = minValue!;
                                                  } else if (double.parse(
                                                          value!) >
                                                      maxValue!) {
                                                    _startValue = maxValue!;
                                                  } else if (double.parse(
                                                          value) <
                                                      minValue!) {
                                                    _startValue = minValue!;
                                                  } else {
                                                    _startValue =
                                                        double.parse(value);
                                                  }
                                                });
                                              },
                                              controller: startController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                label: Text(
                                                  'От',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                hintStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.44,
                                            child: FormBuilderTextField(
                                              name: 'end_value',
                                              onChanged: (value) {
                                                innerSetState(() {
                                                  if (value == '' ||
                                                      value == '0') {
                                                    _endValue = maxValue!;
                                                  } else if (double.parse(
                                                          value!) >
                                                      maxValue!) {
                                                    _endValue = maxValue!;
                                                  } else if (double.parse(
                                                          value) <
                                                      minValue!) {
                                                    _endValue = minValue!;
                                                  } else {
                                                    _endValue =
                                                        double.parse(value);
                                                  }
                                                });
                                              },
                                              controller: endController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                label: Text(
                                                  'До',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                hintStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RangeSlider(
                                        activeColor:
                                            Theme.of(context).disabledColor,
                                        inactiveColor: Colors.grey,
                                        values:
                                            RangeValues(_startValue, _endValue),
                                        min: minValue!,
                                        max: maxValue!,
                                        onChanged: (values) {
                                          innerSetState(() {
                                            _startValue =
                                                values.start.roundToDouble();
                                            _endValue =
                                                values.end.roundToDouble();
                                            startController.text =
                                                values.start.round().toString();
                                            endController.text =
                                                values.end.round().toString();
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                            Func().buildFilterField(filterData,
                                filterDefaultValues, filterValues, context)
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          filterValues = _formKey.currentState!.value;
                          setState(() {
                            String encodedString = filterValues.keys.map((key) {
                              return key +
                                  '=' +
                                  Uri.encodeQueryComponent(
                                      filterValues[key].toString());
                            }).join('&');
                            filters = encodedString;
                            page = 1;
                            hasMore = true;
                            list.clear();
                            productFuture = getProducts(val, filters);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).disabledColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 45),
                        ),
                        child: const Text(
                          'Показать результаты',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ])),
              ),
            );
          }));
}
