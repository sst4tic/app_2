import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/star_rating.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оставить отзыв'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10.h),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: REdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const StarRating(
                  size: 30,
                ),
                SizedBox(width: 10.w),
                const Text(
                  '(0 отзывов)',
                  style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 13,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: REdgeInsets.all(8),
                margin: REdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Арман',
                          style: TextStyle(
                            color: Color(0xFF4A4E64),
                            fontSize: 16,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StarRating(),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '11.09.2022',
                      style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 13,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Отзыв был полезен? ',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.thumb_up_alt_outlined,
                            size: 16, color: Color(0xFF7C7C7C)),
                        SizedBox(width: 2.w),
                        const Text(
                          '1',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        const Icon(Icons.thumb_down_alt_outlined,
                            size: 16, color: Color(0xFF7C7C7C)),
                        SizedBox(width: 2.w),
                        const Text(
                          '0',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
