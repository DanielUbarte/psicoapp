import 'dart:convert';

class EmotionEntry {
  final String id;
  final String userId;
  final String emotion;
  final String emoji;
  final int intensity; // 1 to 5
  final String whatHappened;
  final String whatThought;
  final String whatDid;
  final String? suggestedTool;
  final DateTime date;

  EmotionEntry({
    required this.id,
    required this.userId,
    required this.emotion,
    required this.emoji,
    required this.intensity,
    required this.whatHappened,
    required this.whatThought,
    required this.whatDid,
    this.suggestedTool,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'emotion': emotion,
      'emoji': emoji,
      'intensity': intensity,
      'whatHappened': whatHappened,
      'whatThought': whatThought,
      'whatDid': whatDid,
      'suggestedTool': suggestedTool,
      'date': date.toIso8601String(),
    };
  }

  factory EmotionEntry.fromMap(Map<String, dynamic> map) {
    return EmotionEntry(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      emotion: map['emotion'] ?? '',
      emoji: map['emoji'] ?? '😊',
      intensity: map['intensity'] ?? 3,
      whatHappened: map['whatHappened'] ?? '',
      whatThought: map['whatThought'] ?? '',
      whatDid: map['whatDid'] ?? '',
      suggestedTool: map['suggestedTool'],
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmotionEntry.fromJson(String source) =>
      EmotionEntry.fromMap(json.decode(source));
}
