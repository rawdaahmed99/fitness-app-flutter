class Exercise {
  final String id;
  final String name;
  final String target;
  final String gifUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.target,
    required this.gifUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'].toString(),
      name: json['name'],
      target: json['target'],
      gifUrl: json['gifUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'gifUrl': gifUrl,
    };
  }
}
