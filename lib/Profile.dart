import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:reciperealm/api/UserService.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';
import 'package:reciperealm/widgets/recipe_card.dart';
import 'EditProfile.dart';
import 'FullScreenImagePage.dart';
import 'RecipeDetailView.dart';
import 'api/RecipeService.dart';
import 'data/Recipe.dart';
import 'generated/assets.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final String token;

  final UserService userService = UserService(
    "https://recipe-realm-web-services-production.up.railway.app",
  );

  final RecipeService recipeService = RecipeService();

  Profile({Key? key, required this.token}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _profileData;
  late Future<List<Recipe>> _userRecipes;
  Uint8List? _imageBytes;
  Uint8List? _bannerBytes;

  @override
  void initState() {
    super.initState();
    _profileData = _fetchProfileData();
    _userRecipes = widget.recipeService.getUserRecipes(widget.token);
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final UserService userService = UserService(
      "https://recipe-realm-web-services-production.up.railway.app",
    );
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

  Widget _buildProfileHeader(Map<String, dynamic> userProfile) {
    return Column(
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
                : const AssetImage(Assets.imgDefaultProfileImage)
            as ImageProvider<Object>,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${userProfile['firstName']} ${userProfile['lastName']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
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
    );
  }

  Widget _buildRecipeList(List<Recipe> userRecipes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = userRecipes[index];
        return RecipeCard(
          title: recipe.name,
          rating: '0',
          cookTime: recipe.cookTime,
          thumbnailUrl: recipe.imageLink ?? '',
          onCardTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailView(recipe: recipe),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  "Mi perfil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFFA2751D),
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          actions: <Widget>[
            LogoutButton()
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([_profileData, _userRecipes]),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final Map<String, dynamic> userProfile = snapshot.data![0];
              final List<Recipe> userRecipes = snapshot.data![1] as List<Recipe>;
              return Column(
                children: [
                  Container(
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
                  _buildProfileHeader(userProfile),
                  TabBar(
                    tabs: [
                      Tab(text: 'Mis Recetas'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRecipeList(userRecipes),
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
      ),
    );
  }
}
