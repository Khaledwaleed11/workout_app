import 'dart:async';
import 'package:flutter/material.dart';
import 'main_home_screen.dart'; // 👈 تم تعديل الاستيراد لربط الشاشة الرئيسية الحاوية للشريط

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // الانتقال التلقائي بعد 2.5 ثانية إلى MainHomeScreen
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
            const MainHomeScreen(), // 👈 الانتقال لشاشة الـ MainHomeScreen التي تحتوي على الـ NavigationBar
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A), // Dark Slate
              Color(0xFF1E293B),
              Color(0xFF020617),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vector Icon Frame
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.35),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // App Title
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                          children: [
                            TextSpan(
                              text: 'WORKOUT',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'X',
                              style: TextStyle(color: Colors.orangeAccent),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ELEVATE YOUR FITNESS JOURNEY',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Custom Loader
                      SizedBox(
                        width: 40,
                        height: 3,
                        child: LinearProgressIndicator(
                          color: Colors.orangeAccent,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}