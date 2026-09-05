import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/workoutx_exercise_model.dart';
import '../services/favorites_service.dart';
import 'exercise_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<WorkoutXExerciseModel> _favorites = [];
  List<WorkoutXExerciseModel> _filteredFavorites = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  static const _apiKey =
      'wx_6d679e916799bfd6c68f34590db4d45b1735e0c28171f9a7997c2539';
  static const _headers = {
    'X-WorkoutX-Key': _apiKey,
    'User-Agent': 'Mozilla/5.0',
  };

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favs = await FavoritesService.getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favs;
        _filteredFavorites = favs;
        _isLoading = false;
      });
    }
  }

  void _filterFavorites(String query) {
    if (query.isEmpty) {
      setState(() => _filteredFavorites = _favorites);
    } else {
      setState(() {
        _filteredFavorites = _favorites.where((exercise) {
          final nameMatches =
          exercise.name.toLowerCase().contains(query.toLowerCase());
          final targetMatches =
          exercise.target.toLowerCase().contains(query.toLowerCase());
          return nameMatches || targetMatches;
        }).toList();
      });
    }
  }

  Future<void> _removeFavorite(WorkoutXExerciseModel exercise) async {
    await FavoritesService.toggleFavorite(exercise);
    _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_capitalize(exercise.name)} removed from favorites'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
    isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Favorite Workouts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      )
          : _favorites.isEmpty
          ? _buildEmptyState(isDark)
          : Column(
        children: [
          // 🔍 Search Bar inside Favorites
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFavorites,
              decoration: InputDecoration(
                hintText: 'Search saved exercises...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.orangeAccent,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    _filterFavorites('');
                  },
                )
                    : null,
                filled: true,
                fillColor: surfaceColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 Favorites List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFavorites,
              color: Colors.orangeAccent,
              child: _filteredFavorites.isEmpty
                  ? const Center(
                child: Text('No matching exercises found.'),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredFavorites.length,
                itemBuilder: (context, index) {
                  final exercise = _filteredFavorites[index];
                  return _buildFavoriteCard(
                    exercise,
                    surfaceColor,
                    isDark,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
      WorkoutXExerciseModel exercise,
      Color surfaceColor,
      bool isDark,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(exercise: exercise),
              ),
            );
            _loadFavorites(); // Refresh when returning back
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // 🖼️ Exercise Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 75,
                    height: 75,
                    color: isDark
                        ? const Color(0xFF131C2E)
                        : Colors.grey.shade100,
                    child: CachedNetworkImage(
                      imageUrl: exercise.formattedGifUrl,
                      fit: BoxFit.cover,
                      httpHeaders: _headers,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.fitness_center,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // 📌 Exercise Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        _capitalize(exercise.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildChip(
                            exercise.target,
                            Colors.orangeAccent,
                            isDark,
                          ),
                          const SizedBox(width: 6),
                          _buildChip(
                            exercise.equipment,
                            Colors.blueAccent,
                            isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🗑️ Remove Button
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _removeFavorite(exercise),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _capitalize(label),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: Colors.grey.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any exercise to save it here.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
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