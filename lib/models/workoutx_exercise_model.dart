class WorkoutXExerciseModel {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final String gifUrl;
  final List<String> instructions;

  WorkoutXExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.gifUrl,
    required this.instructions,
  });

  factory WorkoutXExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutXExerciseModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      equipment: json['equipment'] ?? '',
      target: json['target'] ?? '',
      gifUrl: json['gifUrl'] ?? '',
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'target': target,
      'gifUrl': gifUrl,
      'instructions': instructions,
    };
  }

  // التأكد من طريقة عرض الرابط
  String get formattedGifUrl {
    if (gifUrl.startsWith('http')) {
      return gifUrl;
    }
    // لو الرابط محتاج baseURL او تعديل حسب الـ API بتاعك
    return gifUrl;
  }
}