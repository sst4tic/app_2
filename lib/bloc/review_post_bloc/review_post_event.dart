part of 'review_post_bloc.dart';

abstract class ReviewPostEvent {}

class PostReviewEvent extends ReviewPostEvent {
  final String productId;
  final String body;
  final String rating;
  final Completer? completer;

  PostReviewEvent(
      {required this.productId,
      required this.body,
      required this.rating, this.completer});
}
