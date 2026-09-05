import 'package:flutter/material.dart';

class ExerciseImageHeader extends StatelessWidget {
  final String gifUrl;

  const ExerciseImageHeader({super.key, required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: gifUrl.isNotEmpty
            ? Image.network(
          gifUrl,
          fit: BoxFit.contain,
          headers: const {
            'X-WorkoutX-Key':
            'wx_6d679e916799bfd6c68f34590db4d45b1735e0c28171f9a7997c2539',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            );
          },
          errorBuilder: (_, __, ___) => const Icon(
            Icons.fitness_center,
            size: 80,
            color: Colors.orangeAccent,
          ),
        )
            : const Icon(
          Icons.fitness_center,
          size: 80,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}