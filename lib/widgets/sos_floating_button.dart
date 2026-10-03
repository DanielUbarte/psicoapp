import 'package:flutter/material.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/screens/sos_modal.dart';

class SosFloatingButton extends StatelessWidget {
  const SosFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const SosModal(),
        );
      },
      backgroundColor: AppTheme.angryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Text(
        '🆘',
        style: TextStyle(fontSize: 18),
      ),
      label: const Text(
        'SOS',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
