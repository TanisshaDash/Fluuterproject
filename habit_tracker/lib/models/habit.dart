class Habit {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final List<String> completedDates; // Store dates as strings (YYYY-MM-DD)

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.completedDates = const [],
  });

  // Convert to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates,
    };
  }

  // Create from Map
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      completedDates: List<String>.from(json['completedDates'] ?? []),
    );
  }

  // Helper to check if completed today
  bool isCompletedToday() {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return completedDates.contains(todayString);
  }

  // Create a copy with modifications
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<String>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}