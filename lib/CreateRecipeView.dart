import 'package:flutter/material.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';

import 'AddRecipeDetailsView.dart';
import 'api/RecipeService.dart';
import 'data/CreateRecipe.dart';


class CreateRecipeView extends StatefulWidget {
  final String token;
  const CreateRecipeView({Key? key, required this.token}) : super(key: key);

  @override
  _CreateRecipeViewState createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<CreateRecipeView> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String cookTime = '';
  String videoLink = '';
  String imageLink = '';
  List<String> steps = [];

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        CreateRecipe newRecipe = CreateRecipe(
          name: name,
          description: description,
          cookTime: cookTime,
          steps: steps,
          videoLink: videoLink,
          imageLink: imageLink,
        );

        CreateRecipe createdRecipe = await RecipeService().createRecipe(newRecipe, widget.token);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddRecipeDetailsView(recipeId: createdRecipe.id!, token: widget.token),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la receta: $e')));
      }
    }
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
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text(
                "Crear receta",
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre de la Receta'),
              onSaved: (value) => name = value!,
              validator: (value) => value!.isEmpty ? 'Por favor ingresa un nombre' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onSaved: (value) => description = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Tiempo de Cocción'),
              onSaved: (value) => cookTime = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enlace de Video'),
              onSaved: (value) => videoLink = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enlace de Imagen'),
              onSaved: (value) => imageLink = value!,
            ),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: Text('Guardar Receta'),
            ),
          ],
        ),
      ),
    );
  }
}