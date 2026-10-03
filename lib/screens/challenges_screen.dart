import 'package:flutter/material.dart';
import 'package:psicoapp/models/challenge.dart';
import 'package:psicoapp/services/storage_service.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/challenge_card.dart';
import 'package:psicoapp/widgets/custom_button.dart';
import 'package:psicoapp/widgets/section_title.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late List<ChallengeDay> _days;
  bool _isLoading = true;
  String? _userId;

  final List<Map<String, dynamic>> _initialDaysData = [
    {
      'dayNumber': 1,
      'title': 'Día 1: Me valoro',
      'prompt': 'Escribe tres cosas que te gustan de ti.',
    },
    {
      'dayNumber': 2,
      'title': 'Día 2: Mis logros',
      'prompt': 'Reconoce un logro del que estés orgulloso/a.',
    },
    {
      'dayNumber': 3,
      'title': 'Día 3: Fortaleza',
      'prompt': 'Escribe algo que hayas superado.',
    },
    {
      'dayNumber': 4,
      'title': 'Día 4: Autocuidado',
      'prompt': 'Haz algo que disfrutes.',
    },
    {
      'dayNumber': 5,
      'title': 'Día 5: Cuestionamiento',
      'prompt': 'Identifica un pensamiento negativo y cuestiónalo.',
    },
    {
      'dayNumber': 6,
      'title': 'Día 6: Reconocimiento',
      'prompt': 'Escribe una cualidad que otras personas reconocen en ti.',
    },
    {
      'dayNumber': 7,
      'title': 'Día 7: Carta personal',
      'prompt': 'Escribe una carta para ti mismo/a.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadChallengeProgress();
  }

  Future<void> _loadChallengeProgress() async {
    setState(() => _isLoading = true);
    final storage = await StorageService.getInstance();
    final user = storage.getActiveUser();

    if (user != null) {
      _userId = user.id;
      final savedProgress =
          await storage.getChallengeProgress(user.id, 'autoestima_7d');

      if (savedProgress != null) {
        _days = savedProgress.map((item) {
          return ChallengeDay.fromMap(Map<String, dynamic>.from(item));
        }).toList();
      } else {
        _days = _initialDaysData.map((data) {
          return ChallengeDay(
            dayNumber: data['dayNumber'],
            title: data['title'],
            prompt: data['prompt'],
          );
        }).toList();
      }
    } else {
      _days = _initialDaysData.map((data) {
        return ChallengeDay(
          dayNumber: data['dayNumber'],
          title: data['title'],
          prompt: data['prompt'],
        );
      }).toList();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveProgress() async {
    if (_userId == null) return;
    final storage = await StorageService.getInstance();
    final data = _days.map((d) => d.toMap()).toList();
    await storage.saveChallengeProgress(_userId!, 'autoestima_7d', data);
  }

  void _openDayDialog(ChallengeDay day) {
    final responseController =
        TextEditingController(text: day.response ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.2),
                  child: const Text('🌱', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    day.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Prompt Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                day.prompt,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Response Input
            TextField(
              controller: responseController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe tu respuesta o reflexión aquí...',
                labelText: 'Tu reflexión del día',
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                if (day.isCompleted)
                  Expanded(
                    child: CustomButton(
                      text: 'Desmarcar',
                      isSecondary: true,
                      onPressed: () {
                        setState(() {
                          day.isCompleted = false;
                          day.response = null;
                        });
                        _saveProgress();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                if (day.isCompleted) const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: day.isCompleted ? 'Guardar cambios' : 'Completar Día',
                    onPressed: () {
                      setState(() {
                        day.isCompleted = true;
                        day.completedAt = DateTime.now();
                        day.response = responseController.text.trim();
                      });
                      _saveProgress();
                      Navigator.of(ctx).pop();

                      // Check if 7/7 completed
                      if (_completedCount == 7) {
                        _showCompletionCelebration();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionCelebration() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              '¡Reto completado!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '¡Felicitaciones! Has culminado con éxito el Reto de 7 Días de Autoestima. Sigue cultivando tu bienestar diariamente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('¡Excelente!'),
            ),
          ],
        ),
      ),
    );
  }

  int get _completedCount => _days.where((d) => d.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    final progress = _days.isEmpty ? 0.0 : (_completedCount / _days.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Retos Psicológicos'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Challenge Header Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [AppTheme.secondaryColor, AppTheme.primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('🌱', style: TextStyle(fontSize: 32)),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Reto de 7 Días de Autoestima',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Progress Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progreso: $_completedCount de 7 días',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_completedCount == 7) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.happyColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.happyColor),
                        ),
                        child: const Row(
                          children: [
                            Text('🏆', style: TextStyle(fontSize: 28)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '¡Felicidades! Has completado todos los días del reto de autoestima.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SectionTitle(
                      title: 'Días del Reto',
                      subtitle:
                          'Pulsa sobre cada día para realizar la actividad.',
                    ),
                    const SizedBox(height: 12),

                    // Days List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _days.length,
                      itemBuilder: (context, index) {
                        final day = _days[index];
                        return ChallengeDayCard(
                          day: day,
                          onTap: () => _openDayDialog(day),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
