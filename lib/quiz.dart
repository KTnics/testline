import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testattached/quiz_model.dart';
import 'state.dart';
import 'bloc.dart';
import 'event.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, int?> selectedOptions = {};
  Map<int, bool> isSolutionVisible = {};
  double totalMarks = 0.0;
  bool showDetailedSolutions = false;
  int remainingAttempts = 3; // Example maximum mistake count
  Timer? _timer;
  int _remainingTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Access duration from the Quiz model
    final quizBloc = context.read<QuizBloc>();
    if (quizBloc.state is QuizLoaded) {
      final quiz = (quizBloc.state as QuizLoaded).quiz;
      // Convert minutes to seconds
      _remainingTimeInSeconds = (quiz.duration ?? 0) * 60;
    }

    // Start the countdown timer
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds > 0) {
        setState(() {
          _remainingTimeInSeconds--;
        });
      } else {
        // When time is up, auto-submit the quiz
        _submitQuiz();
      }
    });
  }
  void _submitQuiz() {
    // Calculate score and navigate to the results screen
    final quizBloc = context.read<QuizBloc>();
    if (quizBloc.state is QuizLoaded) {
      calculateScore(
        (quizBloc.state as QuizLoaded).quiz.questions,
        (quizBloc.state as QuizLoaded).quiz.correctAnswerMarks ?? 0.0,
        (quizBloc.state as QuizLoaded).quiz.negativeMarks ?? 0.0,
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(totalMarks: totalMarks),
      ),
    );
  }



  void calculateScore(List<Question> questions, double correctMarks, double negativeMarks) {
    double marks = 0.0;
    for (var question in questions) {
      final correctOption = question.options.firstWhere(
            (option) => option.isCorrect == true,
        orElse: () => Option(id: -1, description: 'No correct option found'),
      );

      if (selectedOptions.containsKey(question.id)) {
        final selectedOption = selectedOptions[question.id];
        if (selectedOption == correctOption.id) {
          marks += correctMarks;
        } else {
          marks -= negativeMarks;
        }
      }
    }
    setState(() {
      totalMarks = marks;
    });
  }

  String getFormattedTime() {
    int minutes = _remainingTimeInSeconds ~/ 60;
    int seconds = _remainingTimeInSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('WELCOME'),
        actions: [
          TextButton(
            onPressed: () {
              _submitQuiz();  // Manually submit if needed
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // White color for the text
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final quiz = state.quiz;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Timer Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Time Remaining: ${getFormattedTime()}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  // Quiz Info Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title ?? 'Untitled Quiz',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        if (quiz.description != null)
                          Text(
                            quiz.description!,
                            style: TextStyle(fontSize: 16, color: Colors.green[700]),
                          ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          children: [
                            Text("Topic: ${quiz.topic ?? 'N/A'}"),
                            Text("Difficulty: ${quiz.difficultyLevel ?? 'Unknown'}"),
                            Text("Negative Marks: ${quiz.negativeMarks ?? 0.0}"),
                            Text("Correct Marks: ${quiz.correctAnswerMarks ?? 1.0}"),
                            Text("Max Mistakes: ${quiz.maxMistakeCount ?? 'N/A'}"),
                            Text("Total Questions: ${quiz.questions.length}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Questions Section
                  Column(
                    children: quiz.questions.map((question) {
                      final index = quiz.questions.indexOf(question);

                      isSolutionVisible.putIfAbsent(index, () => false);
                      selectedOptions.putIfAbsent(question.id, () => null);

                      return Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.description ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: question.options.map((option) {
                                  final isSelected =
                                      selectedOptions[question.id] == option.id;

                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        backgroundColor: isSelected
                                            ? Colors.green[400]
                                            : Colors.grey[200],
                                        foregroundColor: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        elevation: isSelected ? 6 : 1,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedOptions[question.id] = option.id;
                                          isSolutionVisible[index] = true;
                                        });
                                      },
                                      child: Text(
                                        option.description ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              if (showDetailedSolutions &&
                                  (isSolutionVisible[index] ?? false))
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    question.detailedSolution ?? 'No solution available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double totalMarks;

  ResultScreen({required this.totalMarks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $totalMarks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(),
                  ),
                );
              },
              child: Text('Back to Quiz'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
