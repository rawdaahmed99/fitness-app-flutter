

class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final int calories;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.calories = 300,
    this.ingredients = const [],
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      thumbnail: map['thumbnail'],
      calories: map['calories'] ?? 300,
      ingredients: map['ingredients'] != null
          ? List<String>.from(map['ingredients'])
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
        'calories': calories,
        'ingredients': ingredients,
      };

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      calories: json['calories'] ?? 300,
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : [],
    );
  }
}
