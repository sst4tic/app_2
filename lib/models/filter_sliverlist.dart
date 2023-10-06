import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FilterSliverList extends StatelessWidget {
  final VoidCallback onSortChanged;
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
              Expanded(
                child: GestureDetector(
                  onTap: onSortChanged,
                  child: Container(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.sliders,
                          color: Colors.grey,
                        ),
                        Text(
                          'Сортировать',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onFilterClick,
                  child: Container(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
              ),
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}
