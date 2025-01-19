import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:testattached/quiz_model.dart';
import 'package:testattached/state.dart';

import 'event.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final response = await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));
      if (response.statusCode == 200) {
        final quiz = Quiz.fromJson(jsonDecode(response.body));
        emit(QuizLoaded(quiz: quiz));
      } else {
        emit(QuizError(error: 'Failed to load quiz data'));
      }
    } catch (e) {
      emit(QuizError(error: e.toString()));
    }
  }
}
