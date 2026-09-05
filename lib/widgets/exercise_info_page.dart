import 'package:flutter/material.dart';

class ExerciseInfoBadge extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ExerciseInfoBadge({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}