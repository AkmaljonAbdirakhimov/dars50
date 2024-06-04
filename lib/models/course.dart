import 'dart:convert';

import 'package:dars50/models/quiz.dart';
import 'package:dars50/models/lesson.dart';

class Course {
  String title;
  List<Lesson> lessons;
  Course({
    required this.title,
    required this.lessons,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'lessons': lessons.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      title: map['title'] ?? '',
      lessons: List<Lesson>.from(map['lessons']?.map((x) => Lesson.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));
}

void addCourse() {
  Course course = Course(
    title: "Salom",
    lessons: [
      Lesson(
        title: "1-Dars",
        quizes: [
          Quiz(
            question: "1-Savol",
            options: ["sa", "ASd", "sd"],
          ),
        ],
      ),
    ],
  );

  // http.post(
  //   url,
  //   body: jsonEncode(
  //     course.toJson(),
  //   ),
  // );
}
