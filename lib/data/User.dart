import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final String location;
  final String bio;
  final DateTime birthDate;
  final List<int>? profileImage;
  final List<int>? bannerImage;

  User({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.bio,
    required this.birthDate,
    this.profileImage,
    this.bannerImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : DateTime.now(),
      profileImage: json['profileImage'] != null ? base64Decode(json['profileImage']) : null,
      bannerImage: json['bannerImage'] != null ? base64Decode(json['bannerImage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'location': location,
      'bio': bio,
      'birthDate': birthDate.toIso8601String(),
      'profileImage': profileImage != null ? base64Encode(profileImage!) : null,
      'bannerImage': bannerImage != null ? base64Encode(bannerImage!) : null,
    };
  }
}
