part of 'feedback_bloc.dart';

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {
  FeedbackLoading({
    this.completer,
  });

  final Completer? completer;

  List<Object?> get props => [completer];
}

class FeedbackLoaded extends FeedbackState {
  FeedbackLoaded({
    required this.feedback,
  });

  final List<FeedbackModel> feedback;

  List<Object?> get props => [feedback];
}

class FeedbackLoadingFailure extends FeedbackState {
  FeedbackLoadingFailure({
    this.exception,
  });

  final Object? exception;

  List<Object?> get props => [exception];
}
