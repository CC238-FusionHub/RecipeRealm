import 'Ingredient.dart';

class RecipeDetail {
   int recipeId;
   Ingredient ingredient;
   String quantity;
   String unit;

  RecipeDetail({
    required this.recipeId,
    required this.ingredient,
    required this.quantity,
    required this.unit,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      recipeId: json['recipeId'],
      ingredient: Ingredient.fromJson(json['ingredient']),
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() => {
    'recipeId': recipeId,
    'ingredient': ingredient.toJson(),
    'quantity': quantity,
    'unit': unit,
  };
}
