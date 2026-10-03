import 'dart:convert';

class ChallengeDay {
  final int dayNumber;
  final String title;
  final String prompt;
  bool isCompleted;
  DateTime? completedAt;
  String? response;

  ChallengeDay({
    required this.dayNumber,
    required this.title,
    required this.prompt,
    this.isCompleted = false,
    this.completedAt,
    this.response,
  });

  Map<String, dynamic> toMap() {
    return {
      'dayNumber': dayNumber,
      'title': title,
      'prompt': prompt,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'response': response,
    };
  }

  factory ChallengeDay.fromMap(Map<String, dynamic> map) {
    return ChallengeDay(
      dayNumber: map['dayNumber'] ?? 1,
      title: map['title'] ?? '',
      prompt: map['prompt'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      response: map['response'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeDay.fromJson(String source) =>
      ChallengeDay.fromMap(json.decode(source));
}

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final int totalDays;
  final List<ChallengeDay> days;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.totalDays,
    required this.days,
  });

  int get completedDaysCount => days.where((d) => d.isCompleted).length;
  double get progressPercentage =>
      totalDays == 0 ? 0.0 : (completedDaysCount / totalDays);
  bool get isFullyCompleted => completedDaysCount == totalDays;
}
