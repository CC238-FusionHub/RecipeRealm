import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/Ingredient.dart';


class IngredientService {
  final String baseUrl = 'https://recipe-realm-web-services-production.up.railway.app/api/v1/ingredients';

  Future<Ingredient> registerIngredient(Ingredient ingredient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(ingredient.toJson()),
    );

    if (response.statusCode == 201) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register ingredient');
    }
  }

  Future<List<Ingredient>> findIngredientByName(String name, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/findByName/$name'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Ingredient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to find ingredient by name. Status code: ${response.statusCode}');
    }
  }
  Future<Ingredient> findIngredientById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/findById/$id'));

    if (response.statusCode == 200) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to find ingredient by id');
    }
  }

  Future<void> deleteIngredientById(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteById/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete ingredient');
    }
  }

}