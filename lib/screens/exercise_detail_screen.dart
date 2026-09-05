import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/workoutx_exercise_model.dart';
import '../services/favorites_service.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final WorkoutXExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _setsCount = 3;
  int _repsCount = 10;
  bool _isFavorite = false;

  static const _apiKey =
      'wx_6d679e916799bfd6c68f34590db4d45b1735e0c28171f9a7997c2539';
  static const _headers = {
    'X-WorkoutX-Key': _apiKey,
    'User-Agent': 'Mozilla/5.0',
  };

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await FavoritesService.isFavorite(widget.exercise.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final backgroundColor =
    isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. 🌟 Hero Image Header using SliverAppBar
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: surfaceColor.withOpacity(0.8),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: surfaceColor.withOpacity(0.8),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _isFavorite ? Colors.redAccent : Colors.grey,
                      size: 22,
                    ),
                    onPressed: () async {
                      // استدعاء دالة التبديل من الـ Service والحصول على الحالة الجديدة
                      final newStatus = await FavoritesService.toggleFavorite(widget.exercise);

                      setState(() {
                        _isFavorite = newStatus; // تحديث المتغير عشان الأيقونة تتغير لونها وشكلها فورا
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              newStatus
                                  ? 'Added to Favorites ❤️'
                                  : 'Removed from Favorites',
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'exercise_img_${widget.exercise.id}',
                    child: Container(
                      color: isDark
                          ? const Color(0xFF131C2E)
                          : Colors.grey.shade100,
                      child: CachedNetworkImage(
                        imageUrl: widget.exercise.formattedGifUrl,
                        fit: BoxFit.contain,
                        httpHeaders: _headers,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orangeAccent,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.network(
                          widget.exercise.formattedGifUrl,
                          fit: BoxFit.contain,
                          headers: _headers,
                          errorBuilder: (context, err, stack) => const Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withOpacity(0.0),
                            backgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. 📝 Exercise Details & Overview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    _capitalize(widget.exercise.name),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        title: 'Target Muscle',
                        value: widget.exercise.target,
                        icon: Icons.track_changes_rounded,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        context,
                        title: 'Equipment',
                        value: widget.exercise.equipment,
                        icon: Icons.fitness_center_rounded,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        context,
                        title: 'Body Part',
                        value: widget.exercise.bodyPart,
                        icon: Icons.accessibility_new_rounded,
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  _buildTrackerCard(context, surfaceColor, isDark),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Execution Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  widget.exercise.instructions.isEmpty
                      ? const Text('No step-by-step instructions available.')
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.exercise.instructions.length,
                    itemBuilder: (context, index) {
                      final isLast = index ==
                          widget.exercise.instructions.length - 1;
                      return _buildTimelineStep(
                        context,
                        stepNumber: index + 1,
                        instruction: widget.exercise.instructions[index],
                        isLast: isLast,
                        isDark: isDark,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              _capitalize(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerCard(
      BuildContext context, Color surfaceColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orangeAccent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(isDark ? 0.05 : 0.1),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text(
            'Target Goal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCounterControl(
                label: 'SETS',
                count: _setsCount,
                onDecrement: () {
                  if (_setsCount > 1) setState(() => _setsCount--);
                },
                onIncrement: () => setState(() => _setsCount++),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildCounterControl(
                label: 'REPS',
                count: _repsCount,
                onDecrement: () {
                  if (_repsCount > 1) setState(() => _repsCount--);
                },
                onIncrement: () => setState(() => _repsCount++),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterControl({
    required String label,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            InkWell(
              onTap: onDecrement,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            InkWell(
              onTap: onIncrement,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
      BuildContext context, {
        required int stepNumber,
        required String instruction,
        required bool isLast,
        required bool isDark,
      }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.15),
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.orangeAccent.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.12),
                  ),
                ),
                child: Text(
                  instruction,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}