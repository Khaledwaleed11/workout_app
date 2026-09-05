import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_app/screens/main_home_screen.dart';

import 'cubits/exercise_cubit.dart';
import 'cubits/theme_cubit.dart';
import 'screens/splash_screen.dart'; // 👈 استيراد الـ Splash
import 'theme/app_theme.dart';

void main() {
  runApp(const WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<ExerciseCubit>(
          create: (context) => ExerciseCubit()..fetchExercises(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'WorkoutX',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(), // 👈 تعيين نقطة بداية التطبيق
          );
        },
      ),
    );
  }
}