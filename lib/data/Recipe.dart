import 'RecipeSteps.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String cookTime;
  final List<RecipeStep> steps;
  final String? videoLink;
  final String? imageLink;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.cookTime,
    required this.steps,
    this.videoLink,
    this.imageLink,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var stepsList = (json['steps'] as List)
        .map((item) => RecipeStep.fromJson(item))
        .toList();

    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cookTime: json['cookTime'],
      steps: stepsList,
      videoLink: json['videoLink'],
      imageLink: json['imageLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cookTime': cookTime,
      'steps': steps.map((step) => step.toJson()).toList(),
      'videoLink': videoLink ?? '',
      'imageLink': imageLink ?? '',
    };
  }
}