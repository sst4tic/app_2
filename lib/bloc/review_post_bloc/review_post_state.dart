part of 'review_post_bloc.dart';

abstract class ReviewPostState {}

class ReviewPostInitial extends ReviewPostState {}

class ReviewPostError extends ReviewPostState {
  final dynamic error;

  ReviewPostError({required this.error});
}