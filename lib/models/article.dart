class ArticleModel {
  final String id;
  final String title;
  final String category; // e.g., Ansiedad, Autoestima, Emociones, Estrés, Comunicación asertiva, Relaciones saludables, Hábitos de estudio
  final String categoryEmoji;
  final String simpleExplanation;
  final String myth;
  final String reality;
  final String practicalTip;
  final String readTime;

  ArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryEmoji,
    required this.simpleExplanation,
    required this.myth,
    required this.reality,
    required this.practicalTip,
    this.readTime = '3 min',
  });
}
