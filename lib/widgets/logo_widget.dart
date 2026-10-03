import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';

class PsicoAppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showSlogan;

  const PsicoAppLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.showSlogan = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback custom vector representation if asset is not found
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.smartphone_rounded,
                        size: size * 0.65,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      Positioned(
                        top: size * 0.22,
                        child: Text(
                          '🧠',
                          style: TextStyle(fontSize: size * 0.42),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF2B6CB0)],
            ).createShader(bounds),
            child: const Text(
              'PSICOAPP',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
        if (showSlogan) ...[
          const SizedBox(height: 6),
          const Text(
            '“Conoce tu mente. Cuida de ti.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
