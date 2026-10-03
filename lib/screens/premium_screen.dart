import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/custom_button.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  void _showSubscriptionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('⭐ ', style: TextStyle(fontSize: 24)),
            Text('PSICOAPP Premium'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Gracias por tu interés en PSICOAPP Premium!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Esta interfaz está completamente preparada para integrarse con Google Play Billing y Apple In-App Purchases.',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes y Suscripción'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, AppTheme.primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      'PSICOAPP PREMIUM',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Potencia tu proceso de autocuidado mental',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Free Plan Card
              _buildPlanCard(
                title: '🆓 Plan Gratuito',
                price: 'US\$0.00 / mes',
                color: Colors.grey.shade100,
                borderColor: Colors.grey.shade300,
                features: [
                  'Registro básico de emociones',
                  'Diario emocional personal',
                  'Artículos de PsicoEduca',
                  'Herramientas básicas de calma y SOS',
                ],
                isCurrent: true,
                buttonText: 'Plan Actual',
                onPressed: null,
              ),
              const SizedBox(height: 16),

              // Premium Plan Card
              _buildPlanCard(
                title: '⭐ PSICOAPP PREMIUM',
                price: 'US\$2.99 / mes',
                color: const Color(0xFFFAF5FF),
                borderColor: AppTheme.accentColor,
                features: [
                  'Todos los retos psicológicos ilimitados',
                  'Diario emocional sin restricciones',
                  'Estadísticas y gráficos de evolución de ánimo',
                  'Programas guiados de 7, 14 y 30 días',
                  'Nuevos artículos y herramientas mensuales',
                ],
                isCurrent: false,
                buttonText: 'Obtener PSICOAPP Premium',
                onPressed: () => _showSubscriptionModal(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required Color color,
    required Color borderColor,
    required List<String> features,
    required bool isCurrent,
    required String buttonText,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isCurrent ? 1.0 : 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? AppTheme.textPrimary : AppTheme.accentColor,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: isCurrent ? Colors.grey : AppTheme.accentColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          CustomButton(
            text: buttonText,
            color: isCurrent ? Colors.grey : AppTheme.accentColor,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
