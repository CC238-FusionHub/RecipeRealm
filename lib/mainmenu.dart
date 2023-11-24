import 'package:flutter/material.dart';
import 'package:reciperealm/api/RecipeService.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';
import 'package:reciperealm/widgets/recipe_card.dart';

import '../data/Recipe.dart';
import 'RecipeDetailView.dart';

class mainmenu extends StatefulWidget {
  final String token;
  const mainmenu({Key? key, required this.token}) : super(key: key);

  @override
  State<mainmenu> createState() => _mainmenuState(token: token);
}

class _mainmenuState extends State<mainmenu> with SingleTickerProviderStateMixin {
  final String token;
  _mainmenuState({required this.token});
  late TabController _tabController;
  RecipeService myService = RecipeService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text(
                "Descubrir",
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
        actions: <Widget>[LogoutButton()],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Nuevos"),
            Tab(text: "Populares"),
            Tab(text: "Siguiendo"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<Recipe>>(
            future: myService.getRecipes(widget.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data is List<Recipe>) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = snapshot.data![index];
                      return RecipeCard(
                        title: recipe.name,
                        rating: '0',
                        cookTime: recipe.cookTime,
                        thumbnailUrl: recipe.imageLink ?? '',
                          onCardTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailView(recipe: recipe),  // Asegúrate de pasar el objeto de receta correcto
                              ),
                            );
                          },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No recipes found'));
                }
              } else {
                // Si snapshot.data es nulo, se maneja aquí.
                return Center(child: Text('No recipes found'));
              }
            },
          ),
          Center(child: Text('Contenido de Populares')),
          Center(child: Text('Contenido de Siguiendo')),
        ],
      ),
    );
  }
}
