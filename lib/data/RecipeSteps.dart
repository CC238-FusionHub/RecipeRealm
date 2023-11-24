class RecipeStep {
  final String description;

  RecipeStep({required this.description});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}