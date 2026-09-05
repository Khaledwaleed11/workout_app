import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/workoutx_exercise_model.dart';

class ExerciseCard extends StatefulWidget {
  final WorkoutXExerciseModel exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  // 🔑 غير المفتاح هنا بالمفتاح الخاص بك
  static const String _apiKey =
      'wx_6d679e916799bfd6c68f34590db4d45b1735e0c28171f9a7997c2539';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 🖼️ عرض الصورة
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: isDark ? Colors.black26 : Colors.grey.shade100,
                  child: CachedNetworkImage(
                    imageUrl: widget.exercise.formattedGifUrl,
                    fit: BoxFit.cover,
                    httpHeaders: const {
                      'X-WorkoutX-Key': _apiKey,
                      'User-Agent': 'Mozilla/5.0',
                    },
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.network(
                      widget.exercise.formattedGifUrl,
                      fit: BoxFit.cover,
                      headers: const {
                        'X-WorkoutX-Key': _apiKey,
                        'User-Agent': 'Mozilla/5.0',
                      },
                      errorBuilder: (context, err, stack) => const Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: Colors.orangeAccent,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 📝 تفاصيل التمرين
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.exercise.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Target: ${widget.exercise.target}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Equipment: ${widget.exercise.equipment}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}