import 'package:flutter/material.dart';
import 'package:psicoapp/models/challenge.dart';
import 'package:psicoapp/theme/app_theme.dart';

class ChallengeDayCard extends StatelessWidget {
  final ChallengeDay day;
  final VoidCallback onTap;

  const ChallengeDayCard({
    super.key,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: day.isCompleted
            ? AppTheme.secondaryColor.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: day.isCompleted
              ? AppTheme.secondaryColor
              : Colors.black.withValues(alpha: 0.06),
          width: day.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: day.isCompleted
              ? AppTheme.secondaryColor
              : AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Text(
            '${day.dayNumber}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: day.isCompleted ? Colors.white : AppTheme.primaryColor,
            ),
          ),
        ),
        title: Text(
          day.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: day.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            day.prompt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        trailing: Icon(
          day.isCompleted
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: day.isCompleted ? AppTheme.secondaryColor : Colors.grey.shade400,
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }
}
