import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/custom_button.dart';

class SosModal extends StatefulWidget {
  const SosModal({super.key});

  @override
  State<SosModal> createState() => _SosModalState();
}

class _SosModalState extends State<SosModal> {
  String? _selectedOption;

  final Map<String, Map<String, dynamic>> _sosOptions = {
    'calm': {
      'emoji': '😰',
      'title': 'Calmarme',
      'toolTitle': 'Respiración de Emergencia (5 segundos)',
      'instructions': [
        'Pon tu mano derecha sobre tu pecho y la izquierda sobre tu abdomen.',
        'Siente cómo entra y sale el aire lentamente.',
        'Cuenta 5 segundos al inhalar y 5 segundos al expulsar.',
        'Repite este ciclo 3 veces enfocando toda tu atención en tu respiración.',
      ]
    },
    'anger': {
      'emoji': '😡',
      'title': 'Controlar mi enojo',
      'toolTitle': 'Enfriamiento Inmediato',
      'instructions': [
        'A Aléjate físicamente de la persona o entorno en este instante.',
        'Sostén un cubo de hielo o lávate las manos con agua fría.',
        'Cuenta regresiva de 100 de 7 en 7 para cambiar el enfoque cerebral.',
      ]
    },
    'express': {
      'emoji': '😔',
      'title': 'Expresar lo que siento',
      'toolTitle': 'Desahogo Sin Filtro',
      'instructions': [
        'Abre una nota o papel en blanco.',
        'Escribe todo lo que pasa por tu mente sin corregir ni juzgar.',
        'Permítete llorar o suspirar si tu cuerpo lo solicita.',
      ]
    },
    'relax': {
      'emoji': '🧘',
      'title': 'Relajarme',
      'toolTitle': 'Escaneo Corporal Rápido',
      'instructions': [
        'Cierra suavemente los ojos.',
        'Tensa tus puños durante 5 segundos y luego suéltalos por completo.',
        'Tensa tus hombros hacia las orejas 5 segundos y desciéndelos.',
        'Nota el contraste entre la tensión y el relax.',
      ]
    },
    'talk': {
      'emoji': '👥',
      'title': 'Hablar con alguien',
      'toolTitle': 'Red de Apoyo y Líneas de Ayuda',
      'instructions': [
        'Contacta a un familiar o amigo de tu entera confianza.',
        'Comunícate con servicios de atención gratuita en salud mental:',
        '• Línea de Emergencia: 911 / 112',
        '• Orientación en Salud Mental (Perú/LATAM): Línea 113 opción 5',
      ]
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.angryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🆘', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modo SOS Emocional',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.angryColor,
                        ),
                      ),
                      Text(
                        'Asistencia rápida para momentos de crisis',
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            if (_selectedOption == null) ...[
              const Text(
                '¿Qué necesitas ahora?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // SOS Options List
              ..._sosOptions.entries.map((entry) {
                final key = entry.key;
                final data = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Text(data['emoji'],
                          style: const TextStyle(fontSize: 26)),
                      title: Text(
                        data['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        setState(() {
                          _selectedOption = key;
                        });
                      },
                    ),
                  ),
                );
              }),
            ] else ...[
              // Option Detail View
              _buildOptionDetailView(_sosOptions[_selectedOption]!),
            ],

            const SizedBox(height: 20),

            // Mandatory Safety Notice
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.angryColor.withValues(alpha: 0.3), width: 1),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: AppTheme.angryColor, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Si estás en peligro inmediato o sientes que podrías hacerte daño, busca ayuda profesional o contacta los servicios de emergencia de tu localidad.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionDetailView(Map<String, dynamic> data) {
    final List<String> steps = List<String>.from(data['instructions']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(data['emoji'], style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data['toolTitle'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...steps.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor)),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                          fontSize: 14, height: 1.35, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Elegir otra opción',
          isSecondary: true,
          onPressed: () {
            setState(() {
              _selectedOption = null;
            });
          },
        ),
      ],
    );
  }
}
