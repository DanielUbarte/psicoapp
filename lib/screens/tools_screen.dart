import 'dart:async';
import 'package:flutter/material.dart';
import 'package:psicoapp/models/tool.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/custom_button.dart';
import 'package:psicoapp/widgets/section_title.dart';
import 'package:psicoapp/widgets/tool_card.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final List<ToolModel> _tools = [
    ToolModel(
      id: 'calm',
      title: 'Necesito calmarme',
      subtitle: 'Ejercicio de respiración guiada 4-4-4.',
      category: ToolCategory.calm,
      iconEmoji: '🧘',
      themeColor: AppTheme.calmColor,
      instructions: [
        'Encuentra una posición cómoda y relaja tus hombros.',
        'Inhala aire lentamente por la nariz durante 4 segundos.',
        'Mantén el aire en tus pulmones durante 4 segundos.',
        'Exhala suavemente por la boca durante 4 segundos.',
        'Repite este ciclo 4 veces hasta sentir mayor calma.'
      ],
    ),
    ToolModel(
      id: 'anger',
      title: 'Estoy enojado/a',
      subtitle: 'Identifica el detonante y regula la intensidad.',
      category: ToolCategory.anger,
      iconEmoji: '😡',
      themeColor: AppTheme.angryColor,
      instructions: [
        'Haz una pausa física: aléjate momentáneamente de la situación.',
        'Identifica la causa principal: ¿qué evento o palabra desató tu enojo?',
        'Separa la persona del problema.',
        'Pregúntate: ¿Qué necesidad tuya no está siendo respetada?',
        'Decide responder con asertividad en lugar de reaccionar impulsivamente.'
      ],
    ),
    ToolModel(
      id: 'worry',
      title: 'Estoy preocupado/a',
      subtitle: 'Diferencia lo que puedes controlar de lo que no.',
      category: ToolCategory.worry,
      iconEmoji: '😰',
      themeColor: AppTheme.anxiousColor,
      instructions: [
        'Escribe en una lista lo que te inquieta.',
        'Clasifica cada ítem: ¿Está dentro de tu control directo o no?',
        'Acepta lo que no puedes controlar (el clima, las acciones de otros).',
        'Enfoca tu energía únicamente en una acción pequeña que SÍ puedes hacer hoy.'
      ],
    ),
    ToolModel(
      id: 'difficult',
      title: 'Momento difícil',
      subtitle: 'Espacio de expresión emocional y autocompasión.',
      category: ToolCategory.difficult,
      iconEmoji: '💔',
      themeColor: AppTheme.sadColor,
      instructions: [
        'Reconoce tu dolor sin juzgarte: Es válido sentirte así.',
        'Trátate con la misma amabilidad con la que tratarías a un buen amigo.',
        'Recuerda que los momentos difíciles son pasajeros.',
        'Tómate un momento para respirar y pedir apoyo si lo necesitas.'
      ],
    ),
    ToolModel(
      id: 'focus',
      title: 'No puedo concentrarme',
      subtitle: 'Técnicas de organización y pausas activas.',
      category: ToolCategory.focus,
      iconEmoji: '💤',
      themeColor: AppTheme.primaryColor,
      instructions: [
        'Divide tu tarea en bloques pequeños de 20-25 minutos.',
        'Elimina distracciones visibles (notificaciones del móvil).',
        'Realiza una sola cosa a la vez.',
        'Toma una pausa de 5 minutos al terminar cada bloque.'
      ],
    ),
  ];

  void _openToolDetail(ToolModel tool) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InteractiveToolDetailScreen(tool: tool),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja de Herramientas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Herramientas de Autocuidado',
                subtitle:
                    'Selecciona el recurso que mejor se adapte a lo que necesitas hoy.',
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tools.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                itemBuilder: (ctx, index) {
                  final tool = _tools[index];
                  return ToolCard(
                    tool: tool,
                    onTap: () => _openToolDetail(tool),
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

class InteractiveToolDetailScreen extends StatefulWidget {
  final ToolModel tool;

  const InteractiveToolDetailScreen({super.key, required this.tool});

  @override
  State<InteractiveToolDetailScreen> createState() =>
      _InteractiveToolDetailScreenState();
}

class _InteractiveToolDetailScreenState
    extends State<InteractiveToolDetailScreen> {
  // Timer for breathing tool
  Timer? _timer;
  int _seconds = 4;
  String _phase = 'Inhala';
  bool _isBreathingActive = false;

  // Controller for worry/anger exercises
  final List<String> _canControlList = [];
  final List<String> _cannotControlList = [];
  final _inputController = TextEditingController();

  void _toggleBreathing() {
    if (_isBreathingActive) {
      _timer?.cancel();
      setState(() {
        _isBreathingActive = false;
        _phase = 'Listo para empezar';
        _seconds = 4;
      });
    } else {
      setState(() {
        _isBreathingActive = true;
        _phase = 'Inhala 🌬️';
        _seconds = 4;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        setState(() {
          if (_seconds > 1) {
            _seconds--;
          } else {
            _seconds = 4;
            if (_phase.startsWith('Inhala')) {
              _phase = 'Mantén 🧘';
            } else if (_phase.startsWith('Mantén')) {
              _phase = 'Exhala 💨';
            } else {
              _phase = 'Inhala 🌬️';
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tool = widget.tool;

    return Scaffold(
      appBar: AppBar(
        title: Text(tool.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tool Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: tool.themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: tool.themeColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Text(tool.iconEmoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tool.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: tool.themeColor.darken(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tool.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Interactive Specific Modules per Tool Category
              if (tool.category == ToolCategory.calm) ...[
                _buildBreathingInteractiveModule(tool),
              ] else if (tool.category == ToolCategory.worry) ...[
                _buildControlCircleInteractiveModule(),
              ] else if (tool.category == ToolCategory.anger) ...[
                _buildAngerTriggerModule(),
              ] else if (tool.category == ToolCategory.difficult) ...[
                _buildCatharsisWritingModule(),
              ] else ...[
                _buildFocusTimerModule(),
              ],

              const SizedBox(height: 28),

              // Instructions List Section
              const Text(
                'Pasos recomendados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...List.generate(tool.instructions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: tool.themeColor,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tool.instructions[index],
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Back Button
              CustomButton(
                text: 'Regresar a Herramientas',
                isSecondary: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingInteractiveModule(ToolModel tool) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: tool.themeColor.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: _isBreathingActive ? 140 : 100,
            height: _isBreathingActive ? 140 : 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tool.themeColor.withValues(alpha: 0.2),
              border: Border.all(color: tool.themeColor, width: 3),
            ),
            child: Center(
              child: Text(
                '$_seconds s',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: tool.themeColor.darken(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _phase,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleBreathing,
            style: ElevatedButton.styleFrom(
              backgroundColor: tool.themeColor,
            ),
            icon: Icon(_isBreathingActive ? Icons.pause : Icons.play_arrow),
            label: Text(_isBreathingActive
                ? 'Pausar respiración'
                : 'Iniciar respiración 4-4-4'),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCircleInteractiveModule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Círculo de Control',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: 'Escribe algo que te preocupe...',
              labelText: 'Añadir preocupación',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'SÍ puedo controlarlo',
                  onPressed: () {
                    if (_inputController.text.trim().isNotEmpty) {
                      setState(() {
                        _canControlList.add(_inputController.text.trim());
                        _inputController.clear();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'NO puedo controlarlo',
                  isSecondary: true,
                  onPressed: () {
                    if (_inputController.text.trim().isNotEmpty) {
                      setState(() {
                        _cannotControlList.add(_inputController.text.trim());
                        _inputController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          if (_canControlList.isNotEmpty || _cannotControlList.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🟢 Puedo Controlar:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      ..._canControlList
                          .map((item) => Text('• $item',
                              style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🔴 Soltar / No controlo:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      ..._cannotControlList
                          .map((item) => Text('• $item',
                              style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAngerTriggerModule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.angryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Reflexión rápida para el enojo:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.angryColor),
          ),
          SizedBox(height: 8),
          Text(
            '1. Toma un vaso de agua o camina durante 60 segundos.\n2. Pregúntate: "¿Vale la pena perder mi paz por esto en 1 año?"\n3. Escribe tu molestia en una hoja y rompéla simbólicamente.',
            style: TextStyle(fontSize: 13.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCatharsisWritingModule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.sadColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💬 Espacio Seguro de Catarsis:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.sadColor),
          ),
          SizedBox(height: 8),
          Text(
            'Está bien no estar bien todo el tiempo. Permítete sentir sin juzgarte. Escribe lo que sientes o simplemente respira profundo.',
            style: TextStyle(fontSize: 13.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusTimerModule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⏱️ Técnica Pomodoro Sugerida:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.primaryColor),
          ),
          SizedBox(height: 8),
          Text(
            '• 25 Minutos de Enfoque Total (Sin teléfono)\n• 5 Minutos de Pausa Activa (Estiramiento o agua)',
            style: TextStyle(fontSize: 13.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
