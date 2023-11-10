import 'RecipeDetail.dart';

class CreateRecipe {
  final int? id;
  final String name;
  final String description;
  final String cookTime;
  final List<String>? steps;
  final String? videoLink;
  final String? imageLink;

  CreateRecipe({
    this.id,
    required this.name,
    required this.description,
    required this.cookTime,
    this.steps,
    this.videoLink,
    this.imageLink,
  });

  factory CreateRecipe.fromJson(Map<String, dynamic> json) {
    List<String> stepsList = (json['steps'] as List?)?.map((item) => item as String).toList() ?? [];

    return CreateRecipe(
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
      'name': name,
      'description': description,
      'cookTime': cookTime,
      'steps': steps,
      'videoLink': videoLink,
      'imageLink': imageLink,
    };
  }

}