import 'RecipeSteps.dart';

class CreateRecipe {
  final int? id;
  final String name;
  final String description;
  final String ingredients;
  final String cookTime;
  final List<RecipeStep>? steps;
  final String? videoLink;
  final String? imageLink;

  CreateRecipe({
    this.id,
    required this.name,
    required this.description,
    required this.cookTime,
    required this.ingredients,
    this.steps,
    this.videoLink,
    this.imageLink,
  });

  factory CreateRecipe.fromJson(Map<String, dynamic> json) {
    var stepsList = (json['steps'] as List?)
        ?.map((item) => RecipeStep.fromJson(item))
        .toList();

    return CreateRecipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: json['ingredients'],
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
      'ingredients': ingredients,
      'cookTime': cookTime,
      'steps': steps?.map((step) => step.toJson()).toList(),
      'videoLink': videoLink ?? '',
      'imageLink': imageLink ?? '',
    };
  }
}