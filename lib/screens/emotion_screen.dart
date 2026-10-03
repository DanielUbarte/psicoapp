import 'package:flutter/material.dart';
import 'package:psicoapp/models/emotion_entry.dart';
import 'package:psicoapp/services/storage_service.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/custom_button.dart';

class EmotionScreen extends StatefulWidget {
  final String selectedEmotion;
  final String selectedEmoji;
  final Color themeColor;

  const EmotionScreen({
    super.key,
    required this.selectedEmotion,
    required this.selectedEmoji,
    required this.themeColor,
  });

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  late String _currentEmotion;
  late String _currentEmoji;
  late Color _currentColor;

  int _intensity = 3;
  final _whatHappenedController = TextEditingController();
  final _whatThoughtController = TextEditingController();
  final _whatDidController = TextEditingController();
  String? _selectedTool;

  bool _isSaving = false;

  final List<Map<String, String>> _availableTools = [
    {'name': 'Respiración', 'emoji': '🧘', 'desc': 'Inhala 4s, mantén 4s y exhala 4s para reducir la tensión.'},
    {'name': 'Escritura emocional', 'emoji': '✍️', 'desc': 'Expresa sin filtro todo lo que sientes en este momento.'},
    {'name': 'Actividad creativa', 'emoji': '🎨', 'desc': 'Dibuja o realiza un pasatiempo manual para liberar la mente.'},
    {'name': 'Relajación', 'emoji': '🎵', 'desc': 'Escucha música suave o sonidos de la naturaleza.'},
  ];

  @override
  void initState() {
    super.initState();
    _currentEmotion = widget.selectedEmotion;
    _currentEmoji = widget.selectedEmoji;
    _currentColor = widget.themeColor;
  }

  Future<void> _saveEmotion() async {
    if (_whatHappenedController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor descríbenos qué ocurrió brevemente.'),
          backgroundColor: AppTheme.angryColor,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final storage = await StorageService.getInstance();
    final user = storage.getActiveUser();

    if (user != null) {
      final entry = EmotionEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        emotion: _currentEmotion,
        emoji: _currentEmoji,
        intensity: _intensity,
        whatHappened: _whatHappenedController.text.trim(),
        whatThought: _whatThoughtController.text.trim(),
        whatDid: _whatDidController.text.trim(),
        suggestedTool: _selectedTool,
        date: DateTime.now(),
      );

      await storage.saveEmotionEntry(entry);
    }

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Emoción registrada exitosamente en tu diario!'),
        backgroundColor: AppTheme.calmColor,
      ),
    );

    Navigator.of(context).pop();
  }

  void _showToolDetails(Map<String, String> tool) {
    setState(() {
      _selectedTool = tool['name'];
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tool['emoji']!, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Herramienta: ${tool['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              tool['desc']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Usar esta herramienta',
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _whatHappenedController.dispose();
    _whatThoughtController.dispose();
    _whatDidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Emoción'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emotion Selected Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _currentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _currentColor, width: 2),
                ),
                child: Row(
                  children: [
                    Text(_currentEmoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emoción seleccionada:',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        Text(
                          _currentEmotion,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _currentColor.darken(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Intensity Rating (1-5)
              const Text(
                '¿Qué tan intensa es tu emoción?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final level = index + 1;
                  final isSelected = _intensity == level;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _intensity = level;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected ? _currentColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? _currentColor : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _currentColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Question 1: ¿Qué ocurrió?
              const Text(
                '¿Qué ocurrió?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _whatHappenedController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe la situación o el evento que desató tu emoción...',
                ),
              ),
              const SizedBox(height: 20),

              // Question 2: ¿Qué pensaste?
              const Text(
                '¿Qué pensaste?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _whatThoughtController,
                decoration: const InputDecoration(
                  hintText: '¿Qué ideas o pensamientos pasaron por tu mente?',
                ),
              ),
              const SizedBox(height: 20),

              // Question 3: ¿Qué hiciste?
              const Text(
                '¿Qué hiciste?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _whatDidController,
                decoration: const InputDecoration(
                  hintText: '¿Cuál fue tu reacción o conducta ante la situación?',
                ),
              ),
              const SizedBox(height: 24),

              // Tools Selection Section
              const Text(
                '¿Quieres utilizar una herramienta?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _availableTools.map((t) {
                  final isSelected = _selectedTool == t['name'];
                  return ChoiceChip(
                    avatar: Text(t['emoji']!),
                    label: Text(t['name']!),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryLight,
                    onSelected: (selected) {
                      _showToolDetails(t);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: 'Guardar emoción',
                isLoading: _isSaving,
                onPressed: _saveEmotion,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
