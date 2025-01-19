import 'package:testattached/quiz_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Quiz quiz;

  QuizLoaded({required this.quiz});
}

class QuizError extends QuizState {
  final String error;

  QuizError({required this.error});
}
