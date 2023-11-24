class Recipe {
  final int id;
  final String name;
  final String description;
  final String ingredients;
  final List<String> steps;
  final String videoLink;
  final String imageLink;


  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.videoLink,
    required this.imageLink,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: json['ingredients'],
      steps: List<String>.from(json['steps'] as List<dynamic>),
      videoLink: json['videoLink'],
      imageLink: json['imageLink'],
    );
  }
}
