import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/RecipeDetail.dart';


class RecipeDetailsService {
  final String baseUrl = "https://recipe-realm-web-services-production.up.railway.app/api/v1/recipe-details";

  Future<RecipeDetail> addRecipeDetail(RecipeDetail recipeDetail) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(recipeDetail.toJson()),
    );

    if (response.statusCode == 201) {
      return RecipeDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al agregar detalle de receta');
    }
  }

  Future<RecipeDetail> getRecipeDetailById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return RecipeDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Detalle de receta no encontrado');
    }
  }

  Future<void> deleteRecipeDetail(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar detalle de receta');
    }
  }
}