class Quiz {
  final int id;
  final String? name;
  final String? title;
  final String? description;
  final String? difficultyLevel;
  final String? topic;
  final DateTime? time;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? duration;
  final DateTime? endTime;
  final double? negativeMarks;
  final double? correctAnswerMarks;
  final bool? shuffle;
  final bool? showAnswers;
  final bool? lockSolutions;
  final bool? isForm;
  final bool? showMasteryOption;
  final String? readingMaterial;
  final String? quizType;
  final bool? isCustom;
  final int? bannerId;
  final int? examId;
  final bool? showUnanswered;
  final DateTime? endsAt;
  final String? liveCount;
  final int? coinCount;
  final int? questionsCount;
  final String? dailyDate;
  final int? maxMistakeCount;
  final List<String> readingMaterials;
  final List<Question> questions;

  Quiz({
    required this.id,
    this.name,
    this.title,
    this.description,
    this.difficultyLevel,
    this.topic,
    this.time,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.endTime,
    this.negativeMarks,
    this.correctAnswerMarks,
    this.shuffle,
    this.showAnswers,
    this.lockSolutions,
    this.isForm,
    this.showMasteryOption,
    this.readingMaterial,
    this.quizType,
    this.isCustom,
    this.bannerId,
    this.examId,
    this.showUnanswered,
    this.endsAt,
    this.liveCount,
    this.coinCount,
    this.questionsCount,
    this.dailyDate,
    this.maxMistakeCount,
    required this.readingMaterials,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      name: json['name'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      topic: json['topic'] as String?,
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      isPublished: json['is_published'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      duration: json['duration'] as int?,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      negativeMarks: (json['negative_marks'] != null) ? double.tryParse(json['negative_marks']) : null,
      correctAnswerMarks: (json['correct_answer_marks'] != null) ? double.tryParse(json['correct_answer_marks'].toString()) : 0.0,
      shuffle: json['shuffle'] as bool?,
      showAnswers: json['show_answers'] as bool?,
      lockSolutions: json['lock_solutions'] as bool?,
      isForm: json['is_form'] as bool?,
      showMasteryOption: json['show_mastery_option'] as bool?,
      readingMaterial: json['reading_material'] as String?,
      quizType: json['quiz_type'] as String?,
      isCustom: json['is_custom'] as bool?,
      bannerId: json['banner_id'] as int?,
      examId: json['exam_id'] as int?,
      showUnanswered: json['show_unanswered'] as bool?,
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at']) : null,
      liveCount: json['live_count'] as String?,
      coinCount: json['coin_count'] as int?,
      questionsCount: json['questions_count'] as int?,
      dailyDate: json['daily_date'] as String?,
      maxMistakeCount: json['max_mistake_count'] as int?,
      readingMaterials: (json['reading_materials'] as List<dynamic>?)?.cast<String>() ?? [],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final String? description;
  final String? detailedSolution;
  final String? difficultyLevel;
  final String? topic;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Option> options;

  Question({
    required this.id,
    this.description,
    this.detailedSolution,
    this.difficultyLevel,
    this.topic,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      description: json['description'] as String?,
      detailedSolution: json['detailed_solution'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      topic: json['topic'] as String?,
      isPublished: json['is_published'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      options: (json['options'] as List<dynamic>?)
          ?.map((o) => Option.fromJson(o as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Option {
  final int id;
  final String? description;
  final bool? isCorrect;

  Option({
    required this.id,
    this.description,
    this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as int,
      description: json['description'] as String?,
      isCorrect: json['is_correct'] as bool?,
    );
  }
}
