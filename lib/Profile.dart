import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:reciperealm/api/UserService.dart';
import 'EditProfile.dart';
import 'FullScreenImagePage.dart';
import 'generated/assets.dart';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  final String token;

  final UserService userService = UserService(
      "https://recipe-realm-web-services-production.up.railway.app"
  );

  Profile({Key? key, required this.token}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _profileData;
  Uint8List? _imageBytes;
  Uint8List? _bannerBytes;

  @override
  void initState() {
    super.initState();
    _profileData = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final UserService userService = UserService(
        "https://recipe-realm-web-services-production.up.railway.app");
    final Map<String, dynamic> userProfile =
    await userService.getLoggedInUserProfile(widget.token);
    if (userProfile['profileImage'] != null) {
      final profileImage = userProfile['profileImage'];
      if (profileImage is String) {
        final decodedImage = base64Decode(profileImage);
        setState(() {
          _imageBytes = decodedImage;
        });
      }
    }
    if (userProfile['bannerImage'] != null) {
      final bannerImage = userProfile['bannerImage'];
      if (bannerImage is String) {
        final decodedBanner = base64Decode(bannerImage);
        setState(() {
          _bannerBytes = decodedBanner;
        });
      }
    }
    return userProfile;
  }

  Future<void> _handleImageSelection(ImageSource source, bool isProfileImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final File imageFile = File(image.path);
      Map<String, dynamic> uploadResponse;
      if (isProfileImage) {
        uploadResponse = await widget.userService.uploadProfileImage(widget.token, imageFile);
      } else {
        uploadResponse = await widget.userService.uploadBannerImage(widget.token, imageFile);
      }
      final String base64Image = uploadResponse['image'];
      setState(() {
        if (isProfileImage) {
          _imageBytes = base64Decode(base64Image);
        } else {
          _bannerBytes = base64Decode(base64Image);
        }
      });
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
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final Map<String, dynamic> userProfile = snapshot.data!;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_bannerBytes != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                              imageBytes: _bannerBytes!,
                              token: widget.token,
                              onImageUpdate: (newImageBytes) {
                                setState(() {
                                  _bannerBytes = newImageBytes;
                                });
                              }),
                        ),
                      );
                    }
                    if (_bannerBytes == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(token: widget.token),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _bannerBytes != null
                            ? MemoryImage(_bannerBytes!)
                            : AssetImage(Assets.imgDefaultBannerImage) as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15.0,
                  top: 100,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_imageBytes != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                    imageBytes: _imageBytes!,
                                    token: widget.token,
                                    onImageUpdate: (newImageBytes) {
                                      setState(() {
                                        _imageBytes = newImageBytes;
                                      });
                                    }),
                              ),
                            );
                          }
                          if (_imageBytes == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(token: widget.token),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : const AssetImage(
                              Assets.imgDefaultProfileImage)
                          as ImageProvider<Object>,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${userProfile['firstName']} ${userProfile['lastName']}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 200),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(token: widget.token),
                              ),
                            );
                          },
                          child: Text('Editar perfil'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No se pudo cargar el perfil'));
          }
        },
      ),
    );
  }
}