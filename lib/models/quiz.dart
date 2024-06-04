import 'dart:convert';

class Quiz {
  String question;
  List<String> options;
  Quiz({
    required this.question,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'question': question});
    result.addAll({'options': options});

    return result;
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      question: map['question'] ?? '',
      options: List<String>.from(map['options']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) => Quiz.fromMap(json.decode(source));
}
