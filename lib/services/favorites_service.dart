import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workoutx_exercise_model.dart';

class FavoritesService {
  static const String _key = 'favorite_exercises_list_v1';

  static Future<List<WorkoutXExerciseModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_key);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((item) => WorkoutXExerciseModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  static Future<bool> isFavorite(String exerciseId) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == exerciseId);
  }

  static Future<bool> toggleFavorite(WorkoutXExerciseModel exercise) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<WorkoutXExerciseModel> favorites = await getFavorites();

      bool isFav = favorites.any((item) => item.id == exercise.id);

      if (isFav) {
        favorites.removeWhere((item) => item.id == exercise.id);
      } else {
        favorites.add(exercise);
      }

      final String encodedList = jsonEncode(
        favorites.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_key, encodedList);

      return !isFav;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}