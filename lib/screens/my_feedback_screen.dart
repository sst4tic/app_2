import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/models/star_rating.dart';
import 'package:yiwumart/util/function_class.dart';
import '../bloc/my_feedback_bloc/feedback_bloc.dart';
import '../../util/feedback.dart';

class MyFeedBackPage extends StatefulWidget {
  const MyFeedBackPage({Key? key}) : super(key: key);

  @override
  State<MyFeedBackPage> createState() => _MyFeedBackPageState();
}

class _MyFeedBackPageState extends State<MyFeedBackPage> {
  final _feedbackBloc = FeedbackBloc();

  @override
  void initState() {
    super.initState();
    _feedbackBloc.add(LoadFeedback());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои отзывы'),
      ),
      body: BlocProvider<FeedbackBloc>(
        create: (context) => FeedbackBloc(),
        child: BlocBuilder<FeedbackBloc, FeedbackState>(
          bloc: _feedbackBloc,
          builder: (context, state) {
            if (state is FeedbackLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FeedbackLoaded) {
              return state.feedback.isEmpty ?
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Icon(
                      Icons.comments_disabled_outlined,
                      size: 75,
                      color: Color.fromRGBO(94, 98, 120, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Нет отзывов',
                    style: TextStyle(
                      color: Color(0xFF2C2D4F),
                      fontSize: 18,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Оставьте свои впечатления о товарах, чтобы\nделиться своим опытом с другими',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5E6278),
                      fontSize: 15.20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Назад',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ) :
              buildFeedback(feedback: state.feedback);
            } else if (state is FeedbackLoadingFailure) {
              return Text(state.exception.toString());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildFeedback({required List<FeedbackModel> feedback}) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: feedback.length,
      itemBuilder: (context, index) {
        final feedbackItem = feedback[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://cdn.yiwumart.org/${feedbackItem.product.media![0].links!.local.thumbnails.s350}',
                      width: 91,
                      height: 65,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedbackItem.product.name.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF181C32),
                            fontSize: 12,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                        ),
                        Text(feedbackItem.date,
                            style: const TextStyle(
                              color: Color(0xFF919191),
                              fontSize: 10,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 2),
                        StarRating(
                          rating: feedbackItem.rating.toDouble(),
                          size: 12,
                        ),
                        Text(
                          feedbackItem.body,
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  // GestureDetector(
                  //   onTap: () {
                  //     // show dropdown
                  //
                  //   },
                  //     child: const Icon(Icons.more_horiz))
                  PopupMenuButton(
                    icon: const Icon(Icons.more_horiz,
                        color: Color.fromRGBO(124, 124, 124, 1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          height: 25,
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Color(0xFF404040),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Редактировать ',
                                style: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w400,
                                  height: 0.11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          height: 25,
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash,
                                color: Color(0xFFD7212D),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Удалить',
                                style: TextStyle(
                                  color: Color(0xFFD7212D),
                                  fontSize: 12,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 'delete') {
                        Func().showDeleteFeedback(
                            context: context,
                            submitCallback: () => _feedbackBloc
                                .add(DeleteFeedback(id: feedbackItem.id)));
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
