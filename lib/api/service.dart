import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Recipe.dart';

class service{
  Future<Map<String,String>> authenticateUser(String email, String password) async{
    final url = Uri.parse("https://recipe-realm-web-services-production.up.railway.app/api/v1/account/login");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final String accessToken = responseData['access_token'];
      final String refreshToken = responseData['refresh_token'];

      return {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
    } else {
      print('Authentication failed with status code: ${response.statusCode}');
      return {
        'access_token': '',
        'refresh_token': '',
      };
    }
  }
  Future<Map<String,String>> registerUser(String firstName, String lastName, String email, String password) async{
    final url = Uri.parse("https://recipe-realm-web-services-production.up.railway.app/api/v1/account/register");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final String accessToken = responseData['access_token'];
      final String refreshToken = responseData['refresh_token'];

      return {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
    } else {
      print('Registration failed with status code: ${response.statusCode}');
      return {
        'access_token': '',
        'refresh_token': '',
      };
    }
  }
  Future<List<Recipe>> getRecipes(String token) async {
    final url = Uri.parse('https://recipe-realm-web-services-production.up.railway.app/api/v1/recipes');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> itemList = jsonDecode(response.body);
      List<Recipe> recipes = itemList.map((item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load recipes');
    }
  }
}