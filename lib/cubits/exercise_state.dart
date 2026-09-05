import 'package:equatable/equatable.dart';
import '../models/workoutx_exercise_model.dart';

abstract class ExerciseState extends Equatable {
  final String selectedCategory;
  const ExerciseState({this.selectedCategory = 'all'});

  @override
  List<Object?> get props => [selectedCategory];
}

class ExerciseInitial extends ExerciseState {
  const ExerciseInitial({super.selectedCategory});
}

class ExerciseLoading extends ExerciseState {
  const ExerciseLoading({super.selectedCategory});
}

class ExerciseLoaded extends ExerciseState {
  final List<WorkoutXExerciseModel> exercises;
  final bool hasMore;

  const ExerciseLoaded({
    required this.exercises,
    required this.hasMore,
    super.selectedCategory,
  });

  @override
  List<Object?> get props => [exercises, hasMore, selectedCategory];
}

class ExerciseError extends ExerciseState {
  final String message;
  const ExerciseError({required this.message, super.selectedCategory});

  @override
  List<Object?> get props => [message, selectedCategory];
}