import 'package:flutter/material.dart';
import 'package:psicoapp/models/user.dart';
import 'package:psicoapp/services/auth_service.dart';
import 'package:psicoapp/services/storage_service.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/widgets/custom_button.dart';
import 'package:psicoapp/widgets/section_title.dart';
import 'package:psicoapp/screens/login_screen.dart';
import 'package:psicoapp/screens/privacy_policy_screen.dart';
import 'package:psicoapp/screens/premium_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _currentUser;
  int _emotionsCount = 0;
  int _challengeDaysCompleted = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final storage = await StorageService.getInstance();
    final user = storage.getActiveUser();

    if (user != null) {
      final entries = await storage.getEmotionEntries(user.id);
      final challengeProgress =
          await storage.getChallengeProgress(user.id, 'autoestima_7d');

      int completedCount = 0;
      if (challengeProgress != null) {
        completedCount = challengeProgress
            .where((item) => item['isCompleted'] == true)
            .length;
      }

      setState(() {
        _currentUser = user;
        _emotionsCount = entries.length;
        _challengeDaysCompleted = completedCount;
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro/a de que deseas cerrar tu sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final storage = await StorageService.getInstance();
      final auth = AuthService(storage);
      await auth.logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar cuenta'),
        content: const Text(
            'ADVERTENCIA: Esta acción eliminará permanentemente tus datos locales, entradas de diario y sesión. ¿Deseas continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.angryColor),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar cuenta'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final storage = await StorageService.getInstance();
      final auth = AuthService(storage);
      await auth.deleteAccount();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta y datos eliminados correctamente.')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showChangePasswordDialog() {
    final newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'La contraseña debe tener al menos 6 caracteres.'),
                    backgroundColor: AppTheme.angryColor,
                  ),
                );
                return;
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña actualizada correctamente.'),
                  backgroundColor: AppTheme.calmColor,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'PSICOAPP es una plataforma de educación psicológica y bienestar personal.\n\n'
            '1. Uso Aceptable: Diseñada para el autoaprendizaje y seguimiento de emociones personal.\n'
            '2. No Sustituto Médico: La aplicación no realiza diagnósticos clínicos ni prescribe tratamientos psicológicos o psiquiátricos.\n'
            '3. Propiedad Intelectual: Los contenidos y herramientas de PSICOAPP son propiedad de sus creadores.\n'
            '4. Responsabilidad: El usuario asume la responsabilidad de su propio proceso de autocuidado.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
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
        title: const Text('Mi Perfil'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Profile Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.secondaryColor
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🧠',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _currentUser?.fullName ?? 'Usuario PSICOAPP',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentUser?.email ?? 'usuario@psicoapp.com',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // User Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Emociones', '$_emotionsCount'),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              _buildStatItem(
                                  'Retos', '$_challengeDaysCompleted/7 d'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Premium Banner Shortcut
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: const Color(0xFFFAF5FF),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE9D8FD),
                          child: Text('⭐', style: TextStyle(fontSize: 22)),
                        ),
                        title: const Text(
                          'PSICOAPP PREMIUM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentColor,
                          ),
                        ),
                        subtitle: const Text(
                          'Obtén estadísticas avanzadas y programas exclusivos.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: AppTheme.accentColor),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PremiumScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    const SectionTitle(title: 'Configuración y Ajustes'),

                    _buildMenuTile(
                      icon: Icons.shield_outlined,
                      title: 'Política de Privacidad',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuTile(
                      icon: Icons.description_outlined,
                      title: 'Términos y Condiciones',
                      onTap: _showTermsDialog,
                    ),
                    _buildMenuTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'Cambiar contraseña',
                      onTap: _showChangePasswordDialog,
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Cerrar sesión',
                      isSecondary: true,
                      icon: Icons.logout_rounded,
                      onPressed: _handleLogout,
                    ),
                    const SizedBox(height: 12),

                    CustomButton(
                      text: 'Eliminar mi cuenta',
                      isSecondary: true,
                      color: AppTheme.angryColor,
                      icon: Icons.delete_forever_rounded,
                      onPressed: _handleDeleteAccount,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
