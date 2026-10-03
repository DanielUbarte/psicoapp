import 'package:flutter/material.dart';
import 'package:psicoapp/models/article.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/article_card.dart';
import 'package:psicoapp/widgets/custom_button.dart';
import 'package:psicoapp/widgets/section_title.dart';

class PsychoEducationScreen extends StatefulWidget {
  const PsychoEducationScreen({super.key});

  @override
  State<PsychoEducationScreen> createState() => _PsychoEducationScreenState();
}

class _PsychoEducationScreenState extends State<PsychoEducationScreen> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  final List<String> _categories = [
    'Todos',
    'Ansiedad',
    'Autoestima',
    'Emociones',
    'Estrés',
    'Comunicación asertiva',
    'Relaciones saludables',
    'Hábitos de estudio',
  ];

  final List<ArticleModel> _articles = [
    ArticleModel(
      id: '1',
      title: 'Entendiendo la Ansiedad y tus Respuestas Corporales',
      category: 'Ansiedad',
      categoryEmoji: '🧠',
      simpleExplanation:
          'La ansiedad es una respuesta natural de alerta del cuerpo ante situaciones percibidas como amenazantes o inciertas.',
      myth: 'La ansiedad es una debilidad y se puede "apagar" si simplemente le echas ganas.',
      reality:
          'La ansiedad involucra procesos fisiológicos y neuroquímicos reales. Requiere herramientas de regulación y empatía.',
      practicalTip:
          'Practica la técnica de conexión a tierra 5-4-3-2-1 cuando sientas hiperventilación o aceleración.',
      readTime: '3 min',
    ),
    ArticleModel(
      id: '2',
      title: 'Construyendo una Autoestima Sana y Compasiva',
      category: 'Autoestima',
      categoryEmoji: '💗',
      simpleExplanation:
          'La autoestima es la valoración intrínseca que hacemos de nosotros mismos, no depende de la aprobación externa.',
      myth: 'Tener buena autoestima significa creerse superior a los demás o perfecto.',
      reality:
          'La verdadera autoestima implica aceptarte con fortalezas y áreas de mejora sin juzgarte con dureza.',
      practicalTip:
          'Sustituye la autocrítica destructiva por la autocompasión: háblate como a tu mejor amigo.',
      readTime: '4 min',
    ),
    ArticleModel(
      id: '3',
      title: 'Validación Emocional: Ninguna Emoción es Mala',
      category: 'Emociones',
      categoryEmoji: '😊',
      simpleExplanation:
          'Las emociones son señales que nos dan información valiosa sobre nuestras necesidades y límites.',
      myth: 'Existen emociones "buenas" y emociones "malas" o tóxicas.',
      reality:
          'Todas las emociones cumplen una función adaptativa y necesaria para nuestra supervivencia y bienestar.',
      practicalTip:
          'Nombra lo que sientes: decir "siento frustración" disminuye la intensidad en el cerebro.',
      readTime: '3 min',
    ),
    ArticleModel(
      id: '4',
      title: 'Gestión del Estrés en el Día a Día',
      category: 'Estrés',
      categoryEmoji: '🧘',
      simpleExplanation:
          'El estrés es la tensión física y mental que experimentamos ante exigencias ambientales alto demandantes.',
      myth: 'El objetivo de la salud mental es vivir un 100% libre de estrés.',
      reality:
          'Un nivel moderado de estrés impulsa la acción; lo dañino es el estrés crónico sin pausas de recuperación.',
      practicalTip:
          'Programa pausas de 5 minutos cada 90 minutos de trabajo continuo para desconectar.',
      readTime: '3 min',
    ),
    ArticleModel(
      id: '5',
      title: 'Comunicación Asertiva: Expresa tus Límites',
      category: 'Comunicación asertiva',
      categoryEmoji: '🗣️',
      simpleExplanation:
          'Es la habilidad de expresar tus opiniones, sentimientos y límites de manera clara, honesta y respetuosa.',
      myth: 'Ser asertivo significa ser agresivo o salirse siempre con la suya.',
      reality:
          'La asertividad respeta tus propios derechos al mismo tiempo que respeta los derechos de los demás.',
      practicalTip:
          'Utiliza mensajes en primera persona: "Yo me siento..." en lugar de señalar "Tú siempre...".',
      readTime: '4 min',
    ),
    ArticleModel(
      id: '6',
      title: 'Vínculos Seguros en Relaciones Saludables',
      category: 'Relaciones saludables',
      categoryEmoji: '👥',
      simpleExplanation:
          'Relacionarse de forma saludable requiere reciprocity, respeto mutuo y espacio para la individualidad.',
      myth: 'En una relación verdadera no deben existir desacuerdos ni discusiones.',
      reality:
          'Los desacuerdos son normales; lo crucial es la forma respetuosa e igualitaria en que se resuelven.',
      practicalTip:
          'Establece acuerdos claros y no asumas que la otra persona adivina tus expectativas.',
      readTime: '5 min',
    ),
    ArticleModel(
      id: '7',
      title: 'Hábitos de Estudio sin Cargar con Ansiedad',
      category: 'Hábitos de estudio',
      categoryEmoji: '📚',
      simpleExplanation:
          'Aprender a organizar el tiempo académico mejora el rendimiento y preserva tu salud mental.',
      myth: 'Estudiar toda la noche previa al examen garantiza mejores resultados.',
      reality:
          'La privación de sueño deteriora la memoria a corto plazo y aumenta el nivel de ansiedad.',
      practicalTip:
          'Aplica el repaso espaciado en sesiones cortas distribuidas a lo largo de la semana.',
      readTime: '4 min',
    ),
  ];

  List<ArticleModel> get _filteredArticles {
    return _articles.where((article) {
      final matchesCategory = _selectedCategory == 'Todos' ||
          article.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.simpleExplanation
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openArticleDetail(ArticleModel article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(article.categoryEmoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Simple Explanation
              const Text(
                'Explicación sencilla:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                article.simpleExplanation,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Myth Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.angryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('❌ ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Mito común',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.angryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.myth,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Reality Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.calmColor.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('✅ ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Realidad psicológica',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.calmColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.reality,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Practical Tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('💡 ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Consejo práctico',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.practicalTip,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Cerrar artículo',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PsicoEduca'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Educación Psicológica',
                subtitle:
                    'Artículos y conceptos clave para entender tu mente.',
              ),
              const SizedBox(height: 12),

              // Search Input
              TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar artículo o tema...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Categories Horizontal List
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primaryColor,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Articles List
              Expanded(
                child: _filteredArticles.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron artículos para tu búsqueda.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = _filteredArticles[index];
                          return ArticleCard(
                            article: article,
                            onTap: () => _openArticleDetail(article),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
