part of 'feedback_bloc.dart';

abstract class FeedbackEvent {}

class LoadFeedback extends FeedbackEvent {
  LoadFeedback({
    this.completer,
  });

  final Completer? completer;

  List<Object?> get props => [completer];
}

class DeleteFeedback extends FeedbackEvent {
  DeleteFeedback({
    required this.id,
  });

  final int id;

  List<Object?> get props => [id];
}