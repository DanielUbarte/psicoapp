import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/utils/constants.dart';
import 'package:psicoapp/widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final bool isSelectableMode;

  const PrivacyPolicyScreen({
    super.key,
    this.isSelectableMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Política de Privacidad',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Protegemos tu información y tu bienestar.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Content Sections
                    _buildSectionItem(
                      icon: Icons.lock_outline,
                      title: 'Privacidad de tus registros',
                      description:
                          'Los registros emocionales y de diario son información estrictamente privada. Tu bienestar e intimidad son nuestra prioridad.',
                    ),
                    _buildSectionItem(
                      icon: Icons.storage_rounded,
                      title: 'Almacenamiento seguro',
                      description:
                          'Tus datos se guardan de forma segura localmente en tu dispositivo, manteniendo total confidencialidad.',
                    ),
                    _buildSectionItem(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: 'No venta de datos',
                      description:
                          'PSICOAPP no vende, comercializa ni comparte tu información personal con terceros para fines publicitarios.',
                    ),
                    _buildSectionItem(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Control total de tu información',
                      description:
                          'Tienes la libertad y la opción de solicitar eliminar tus datos y tu cuenta en cualquier momento desde tu Perfil.',
                    ),
                    const SizedBox(height: 16),

                    // Important Notice Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppTheme.angryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppTheme.angryColor,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Aviso Importante',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.angryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppConstants.medicalDisclaimer,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Volver',
                      isSecondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  if (isSelectableMode) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Aceptar y continuar',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
