import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciperealm/api/UserService.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:reciperealm/widgets/confirmation_dialog.dart';

import 'FullScreenImagePage.dart';
import 'generated/assets.dart';

class profile extends StatefulWidget {
  final String token;
  const profile({Key? key, required this.token}) : super(key: key);

  @override
  _profileState createState() => _profileState(token: token);
}

class _profileState extends State<profile> {
  final String token;
  _profileState({required this.token});

  late Future<Map<String, dynamic>> _profileData;

  final picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfileData();
  }

  Future<Map<String, dynamic>> fetchProfileData({Uint8List? updatedImageBytes}) async {
    if (updatedImageBytes != null) {
      setState(() {
        _imageBytes = updatedImageBytes;
      });
      return {};
    }

    UserService userService = UserService("https://recipe-realm-web-services-production.up.railway.app");
    Map<String, dynamic> userProfile = await userService.getLoggedInUserProfile(token);
    if (userProfile['profileImage'] != null) {
      final profileImage = userProfile['profileImage'];
      if (profileImage is String) {
        final decodedImage = base64Decode(profileImage);
        setState(() {
          _imageBytes = decodedImage;
        });
      }
    }
    return userProfile;
  }

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        try {
          final tempFile = File('${Directory.systemTemp.path}/${DateTime.now().toIso8601String()}.png');
          await tempFile.writeAsBytes(imageBytes);

          UserService userService = UserService("https://recipe-realm-web-services-production.up.railway.app");
          Map<String, dynamic> updatedUserProfile = await userService.uploadProfileImage(token, tempFile);
          fetchProfileData(updatedImageBytes: imageBytes);
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MI PERFIL",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFA2751D),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _profileData,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> userProfile = snapshot.data!;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_imageBytes != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(imageBytes: _imageBytes!),
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(_imageBytes!)
                        : AssetImage(Assets.imgDefaultProfileImage) as ImageProvider<Object>,
                  ),
                ),
                Text('${userProfile['firstName']} ${userProfile['lastName']}'),
               //TODO USERNAME
              ],
            );
          } else {
            return Center(child: Text('No se pudo cargar el perfil'));
          }
        },
      ),
    );
  }
}
