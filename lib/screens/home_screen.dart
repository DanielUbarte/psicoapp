import 'package:flutter/material.dart';
import 'package:psicoapp/services/storage_service.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/emotion_card.dart';
import 'package:psicoapp/widgets/section_title.dart';
import 'package:psicoapp/screens/emotion_screen.dart';
import 'package:psicoapp/screens/psycho_education_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToJournal;
  final VoidCallback? onNavigateToChallenges;
  final VoidCallback? onNavigateToTools;

  const HomeScreen({
    super.key,
    this.onNavigateToJournal,
    this.onNavigateToChallenges,
    this.onNavigateToTools,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Usuario';
  int _entriesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await StorageService.getInstance();
    final user = storage.getActiveUser();
    if (user != null) {
      final entries = await storage.getEmotionEntries(user.id);
      setState(() {
        _userName = user.fullName.split(' ').first;
        _entriesCount = entries.length;
      });
    }
  }

  void _onEmotionSelected(String emotion, String emoji, Color color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmotionScreen(
          selectedEmotion: emotion,
          selectedEmoji: emoji,
          themeColor: color,
        ),
      ),
    ).then((_) => _loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF3182CE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '🧠',
                              style: TextStyle(fontSize: 28),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PSICOAPP',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Conoce tu mente. Cuida de ti.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PsychoEducationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.school_outlined,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'PsicoEduca',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '¡Hola, $_userName! 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _entriesCount == 0
                          ? 'Comienza registrando cómo te sientes en este momento.'
                          : 'Has registrado $_entriesCount entradas emocionales en tu diario.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Emotion Selector Section
              const SectionTitle(
                title: '¿Cómo te sientes hoy?',
                subtitle: 'Selecciona una emoción para registrar tu estado de ánimo.',
              ),
              const SizedBox(height: 12),

              // Emotion Cards Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: [
                  EmotionCard(
                    emoji: '😊',
                    label: 'Feliz',
                    color: AppTheme.happyColor,
                    onTap: () =>
                        _onEmotionSelected('Feliz', '😊', AppTheme.happyColor),
                  ),
                  EmotionCard(
                    emoji: '😌',
                    label: 'Tranquilo/a',
                    color: AppTheme.calmColor,
                    onTap: () => _onEmotionSelected(
                        'Tranquilo/a', '😌', AppTheme.calmColor),
                  ),
                  EmotionCard(
                    emoji: '😔',
                    label: 'Triste',
                    color: AppTheme.sadColor,
                    onTap: () =>
                        _onEmotionSelected('Triste', '😔', AppTheme.sadColor),
                  ),
                  EmotionCard(
                    emoji: '😡',
                    label: 'Enojado/a',
                    color: AppTheme.angryColor,
                    onTap: () => _onEmotionSelected(
                        'Enojado/a', '😡', AppTheme.angryColor),
                  ),
                  EmotionCard(
                    emoji: '😰',
                    label: 'Ansioso/a',
                    color: AppTheme.anxiousColor,
                    onTap: () => _onEmotionSelected(
                        'Ansioso/a', '😰', AppTheme.anxiousColor),
                  ),
                  EmotionCard(
                    emoji: '😐',
                    label: 'Neutral',
                    color: AppTheme.neutralColor,
                    onTap: () => _onEmotionSelected(
                        'Neutral', '😐', AppTheme.neutralColor),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Action Cards
              const SectionTitle(
                title: 'Descubre más en PSICOAPP',
                subtitle: 'Herramientas y actividades preparadas para ti.',
              ),
              const SizedBox(height: 12),

              // Retos Shortcut Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.2),
                    child: const Text('🌱', style: TextStyle(fontSize: 22)),
                  ),
                  title: const Text(
                    'Reto de Autoestima (7 Días)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Escribe tres cosas que te gustan de ti hoy.',
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: widget.onNavigateToChallenges,
                ),
              ),
              const SizedBox(height: 12),

              // Herramientas Shortcut Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryLight,
                    child: Text('🧘', style: TextStyle(fontSize: 22)),
                  ),
                  title: const Text(
                    'Caja de Herramientas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Ejercicios guiados de respiración, enojo y concentración.',
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: widget.onNavigateToTools,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
