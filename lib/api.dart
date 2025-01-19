import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testattached/quiz_model.dart';

Future<Quiz> fetchQuiz() async {
  final response = await http.get(
    Uri.parse('https://api.jsonserve.com/Uw5CrX'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return Quiz.fromJson(jsonData);
  } else {
    throw Exception('Failed to load quiz');
  }
}
