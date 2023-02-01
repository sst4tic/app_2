import 'package:flutter/material.dart';

import '../catalog_screens/catalog_item.dart';
class FilterSliverList extends StatelessWidget {
  final ValueChanged<String> onSortChanged;
  final VoidCallback onFilterClick;
  final val;
  const FilterSliverList({

    Key? key,
    required this.onSortChanged,
    required this.onFilterClick,
    required this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 7, right: 7),
                width: MediaQuery.of(context).size.width * 0.46,
                height: 49.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                    menuMaxHeight: 200,
                    hint: const Text(
                      'Сортировать',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: val,
                    icon: const Icon(
                      Icons.sort_rounded,
                      color: Colors.grey,
                    ),
                    items: orderByMap.keys.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          orderByMap[value]!,
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: val == value
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      onSortChanged(value.toString());
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: onFilterClick,
                child: Container(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  width: MediaQuery.of(context).size.width * 0.46,
                  height: 49.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Фильтры',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}