import 'RecipeDetail.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String cookTime;
  final List<String> steps;
  final String? videoLink;
  final String? imageLink;
  final List<RecipeDetail> details;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.cookTime,
    required this.steps,
    this.videoLink,
    this.imageLink,
    required this.details,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var list = json['details'] as List;
    List<RecipeDetail> detailsList = list.map((i) => RecipeDetail.fromJson(i)).toList();

    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cookTime: json['cookTime'],
      steps: List<String>.from(json['steps']),
      videoLink: json['videoLink'],
      imageLink: json['imageLink'],
      details: detailsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cookTime': cookTime,
    'steps': steps,
    'videoLink': videoLink ?? '',
    'imageLink': imageLink  ?? '',
    'details': details.map((detail) => detail.toJson()).toList(),
  };
}
