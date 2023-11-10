import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import '../data/User.dart';

class UserService {
  final String baseUrl;

  UserService(this.baseUrl);

  Future<Map<String, dynamic>> getLoggedInUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage(String token, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/v1/user/upload-profile-image'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      var errorData = await response.stream.bytesToString();
      throw Exception('Failed to upload image: $errorData');
    }
  }

  Future<Map<String, dynamic>> uploadBannerImage(String token, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/v1/user/upload-banner-image'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      var errorData = await response.stream.bytesToString();
      throw Exception('Failed to upload image: $errorData');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(String token, User userDto) async {
    final Uri uri = Uri.parse('$baseUrl/api/v1/user/update-profile');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(userDto.toJson());

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'updatedUser': json.decode(response.body),
      };
    } else {
      return {
        'success': false,
        'error': 'Failed to update user profile: ${response.body}',
      };
    }
  }
}