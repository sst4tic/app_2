import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/models/star_rating.dart';
import 'package:yiwumart/util/styles.dart';

import '../bloc/review_post_bloc/review_post_bloc.dart';

class CreateFeedbackPage extends StatefulWidget {
  const CreateFeedbackPage({Key? key, required this.prodId}) : super(key: key);

  final String prodId;

  @override
  State<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends State<CreateFeedbackPage> {
  final reviewBloc = ReviewPostBloc();
  final TextEditingController _commentController = TextEditingController();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оставить отзыв'),
      ),
      body: BlocProvider(
        create: (context) => ReviewPostBloc(),
        child: BlocBuilder<ReviewPostBloc, ReviewPostState>(
          bloc: reviewBloc,
          builder: (context, state) {
            if (state is ReviewPostError) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: REdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Как вам товар?',
                        style: TextStyle(
                          color: Color(0xFF181C32),
                          fontSize: 16,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      StarRating(
                        rating: rating,
                        onRatingChanged: (v) {
                          setState(() {
                            rating = v;
                          });
                        },
                        size: 35,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: REdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Расскажите подробнее',
                        style: TextStyle(
                          color: Color(0xFF181C32),
                          fontSize: 16,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: _commentController,
                        decoration: InputDecorations(hintText: 'Введите текст')
                            .editDecoration
                            .copyWith(
                                contentPadding: REdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFFDADADA)),
                                )),
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        minLines: 15,
                        maxLines: 15,
                      ),
                      SizedBox(height: 5.h),
                      const Text(
                        'Ваш отзыв будет опубликован на странице товара',
                        style: TextStyle(
                          color: Color(0xFF7C7C7C),
                          fontSize: 13,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 45),
                    ),
                    onPressed: () {
                      reviewBloc.add(PostReviewEvent(
                          productId: widget.prodId,
                          body: _commentController.text,
                          rating: rating.toString().substring(0, 1)));
                    },
                    child: const Text(
                      'Отправить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
