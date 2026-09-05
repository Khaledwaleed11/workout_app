import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/workoutx_exercise_model.dart';
import '../services/workoutx_api_service.dart';
import 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(const ExerciseInitial());

  List<WorkoutXExerciseModel> _allExercises = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String _currentCategory = 'all';
  String _searchQuery = '';

  // 1️⃣ جلب التمارين لأول مرة أو التحديث
  Future<void> fetchExercises({bool isRefresh = false}) async {
    if (_isFetchingMore) return;

    if (isRefresh) {
      _offset = 0;
      _hasMore = true;
      _allExercises.clear();
    }

    if (!_hasMore && !isRefresh) return;

    if (_allExercises.isEmpty) {
      emit(ExerciseLoading(selectedCategory: _currentCategory));
    } else {
      _isFetchingMore = true;
    }

    try {
      final newExercises = await WorkoutXApiService.fetchExercises(
        limit: _limit,
        offset: _offset,
        bodyPart: _currentCategory == 'all' ? null : _currentCategory,
      );

      if (newExercises.length < _limit) {
        _hasMore = false;
      }

      _offset += _limit;
      _allExercises.addAll(newExercises);

      _applyFilterAndEmit();
    } catch (e) {
      emit(ExerciseError(
        message: e.toString().replaceAll('Exception: ', ''),
        selectedCategory: _currentCategory,
      ));
    } finally {
      _isFetchingMore = false;
    }
  }

  // 2️⃣ اختيار قسم جديد
  void selectCategory(String category) {
    if (_currentCategory == category) return;

    _currentCategory = category;
    _searchQuery = '';
    _offset = 0;
    _hasMore = true;
    _allExercises.clear();

    // نمرر القسم المختار فوراً في حالة الـ Loading ليتحدث شكل الزرار في الـ UI
    emit(ExerciseLoading(selectedCategory: _currentCategory));
    fetchExercises();
  }

  // 3️⃣ البحث في التمارين
  void searchExercises(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilterAndEmit();
  }

  void _applyFilterAndEmit() {
    if (_searchQuery.isEmpty) {
      emit(ExerciseLoaded(
        exercises: List.from(_allExercises),
        hasMore: _hasMore,
        selectedCategory: _currentCategory,
      ));
    } else {
      final filtered = _allExercises.where((ex) {
        final nameMatch = ex.name.toLowerCase().contains(_searchQuery);
        final targetMatch = ex.target.toLowerCase().contains(_searchQuery);
        final equipMatch = ex.equipment.toLowerCase().contains(_searchQuery);
        return nameMatch || targetMatch || equipMatch;
      }).toList();

      emit(ExerciseLoaded(
        exercises: filtered,
        hasMore: false,
        selectedCategory: _currentCategory,
      ));
    }
  }
}