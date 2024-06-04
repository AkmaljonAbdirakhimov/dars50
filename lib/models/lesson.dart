import 'dart:convert';

import 'package:dars50/models/quiz.dart';

class Lesson {
  String title;
  List<Quiz> quizes;
  Lesson({
    required this.title,
    required this.quizes,
  });

  Lesson copyWith({
    String? title,
    List<Quiz>? quizes,
  }) {
    return Lesson(
      title: title ?? this.title,
      quizes: quizes ?? this.quizes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'quizes': quizes.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      title: map['title'] ?? '',
      quizes: List<Quiz>.from(map['quizes']?.map((x) => Quiz.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(String source) => Lesson.fromMap(json.decode(source));
}
