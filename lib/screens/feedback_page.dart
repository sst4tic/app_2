import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/star_rating.dart';
import '../util/product_item.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key, required this.reviews}) : super(key: key);
  final List<Reviews> reviews;

  @override
  Widget build(BuildContext context) {
    double calculateAverageRating(List<Reviews> reviews) {
      if (reviews.isEmpty) {
        return 0.0;
      }

      int totalRating = 0;

      for (var review in reviews) {
        totalRating += review.rating;
      }

      double averageRating = totalRating / reviews.length;

      return averageRating;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы'),
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
                StarRating(
                  size: 30,
                  rating: calculateAverageRating(reviews),
                ),
                SizedBox(width: 10.w),
                Text(
                  '(${reviews.length} отзывов)',
                  style: const TextStyle(
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
            itemCount: reviews.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: REdgeInsets.all(8),
                margin: REdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          review.user.fullName ?? 'Пользователь',
                          style: const TextStyle(
                            color: Color(0xFF4A4E64),
                            fontSize: 16,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StarRating(
                          rating: review.rating.toDouble(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review.date,
                      style: const TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 13,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      review.body,
                      style: const TextStyle(
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
