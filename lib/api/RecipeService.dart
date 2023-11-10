import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/CreateRecipe.dart';
import '../data/Recipe.dart';


class RecipeService {
  final String baseUrl = 'https://recipe-realm-web-services-production.up.railway.app/api/v1/recipes';

  Future<List<Recipe>> getRecipes(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes = body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe> getRecipeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  Future<CreateRecipe> createRecipe(CreateRecipe createRecipe, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(createRecipe.toJson()),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreateRecipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create recipe. Status code: ${response.statusCode}');
    }
  }

  Future<List<Recipe>> getRecipesByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/by-name/$name'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes = body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes by name');
    }
  }

  Future<List<Recipe>> getRecipesByIngredient(String ingredientName) async {
    final response = await http.get(Uri.parse('$baseUrl/by-ingredient/$ingredientName'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes = body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes by ingredient');
    }
  }

  Future<void> deleteRecipe(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to delete recipe');
    }
  }

}