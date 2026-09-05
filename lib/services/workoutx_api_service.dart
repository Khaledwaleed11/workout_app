import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/workoutx_exercise_model.dart';

class WorkoutXApiService {
  static const String _baseUrl = 'https://api.workoutxapp.com/v1';
  static const String _apiKey =
      'wx_6d679e916799bfd6c68f34590db4d45b1735e0c28171f9a7997c2539';

  // 💡 In-Memory Cache لمنع استهلاك الـ 30 طلب في الدقيقة
  static final Map<String, List<WorkoutXExerciseModel>> _cache = {};

  static Map<String, String> get _headers => {
    'X-WorkoutX-Key': _apiKey,
    'Content-Type': 'application/json',
  };

  static Future<List<WorkoutXExerciseModel>> fetchExercises({
    int limit = 20,
    int offset = 0,
    String? bodyPart,
  }) async {
    String endpoint = '$_baseUrl/exercises?limit=$limit&offset=$offset';
    if (bodyPart != null && bodyPart.isNotEmpty && bodyPart != 'all') {
      endpoint =
      '$_baseUrl/exercises/bodyPart/$bodyPart?limit=$limit&offset=$offset';
    }

    // 👈 إذا البيانات موجودة في الكاش رجعها فوراً
    if (_cache.containsKey(endpoint)) {
      if (kDebugMode) print('⚡ Loaded from Cache: $endpoint');
      return _cache[endpoint]!;
    }

    try {
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: _headers,
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> rawList = [];
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          rawList = decoded['data'] ??
              decoded['results'] ??
              decoded['exercises'] ??
              [];
        }

        final List<WorkoutXExerciseModel> list = [];
        for (var item in rawList) {
          try {
            list.add(WorkoutXExerciseModel.fromJson(item));
          } catch (e) {
            if (kDebugMode) print('⚠️ Parsing Error: $e');
          }
        }

        // حفظ في الكاش
        _cache[endpoint] = list;
        return list;
      } else if (response.statusCode == 429) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final int retryAfter = body['retryAfter'] ?? 10;

        throw Exception(
            'تجاوزت حد الطلبات المسموح به (30 طلب/دقيقة). انتظر $retryAfter ثواني.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال بالإنترنت.');
    } catch (e) {
      rethrow;
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}