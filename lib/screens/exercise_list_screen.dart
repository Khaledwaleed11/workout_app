import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/exercise_cubit.dart';
import '../cubits/exercise_state.dart';
import '../cubits/theme_cubit.dart';
import '../widgets/category_filter.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'all',
    'chest',
    'back',
    'cardio',
    'lower arms',
    'lower legs',
    'neck',
    'shoulders',
    'upper arms',
    'upper legs',
    'waist',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      context.read<ExerciseCubit>().fetchExercises();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutX Exercises'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<ExerciseCubit>().searchExercises(value);
              },
              decoration: InputDecoration(
                hintText: 'Search exercise, muscle, or equipment...',
                prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ExerciseCubit>().searchExercises('');
                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category Filter Bar
          BlocBuilder<ExerciseCubit, ExerciseState>(
            buildWhen: (previous, current) =>
            current is ExerciseLoaded || current is ExerciseLoading,
            builder: (context, state) {
              final selectedCategory = state is ExerciseLoaded
                  ? state.selectedCategory
                  : 'all';

              return CategoryFilterBar(
                categories: _categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  _searchController.clear();
                  context.read<ExerciseCubit>().selectCategory(category);
                },
              );
            },
          ),

          // Main Content
          Expanded(
            child: BlocConsumer<ExerciseCubit, ExerciseState>(
              listener: (context, state) {
                if (state is ExerciseError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ExerciseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }

                if (state is ExerciseError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context
                              .read<ExerciseCubit>()
                              .fetchExercises(isRefresh: true),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ExerciseLoaded) {
                  if (state.exercises.isEmpty) {
                    return const Center(
                      child: Text('لا توجد تمارين متاحة'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<ExerciseCubit>()
                        .fetchExercises(isRefresh: true),
                    color: Colors.orangeAccent,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: state.exercises.length +
                          (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.exercises.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          );
                        }

                        final exercise = state.exercises[index];
                        return ExerciseCard(
                          exercise: exercise,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailScreen(
                                  exercise: exercise,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}