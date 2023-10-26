class Recipe {
  final int id;
  final String name;
  final String description;
  final List<String> steps;
  final String videoLink;
  final String imageLink;
  // Add more properties as needed

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.videoLink,
    required this.imageLink,
    // Add more properties as needed
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      steps: List<String>.from(json['steps']),
      videoLink: json['videoLink'],
      imageLink: json['imageLink'],
      // Map more properties as needed
    );
  }
}
