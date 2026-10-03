import 'package:flutter/material.dart';

enum ToolCategory {
  calm,
  anger,
  worry,
  difficult,
  focus,
}

class ToolModel {
  final String id;
  final String title;
  final String subtitle;
  final ToolCategory category;
  final String iconEmoji;
  final Color themeColor;
  final List<String> instructions;

  ToolModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.iconEmoji,
    required this.themeColor,
    required this.instructions,
  });
}
