import 'package:flutter/material.dart';
import 'package:reciperealm/data/Recipe.dart';

import 'data/RecipeSteps.dart';

class RecipeDetailView extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailView({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (recipe.imageLink != null && recipe.imageLink!.isNotEmpty)
              Image.network(recipe.imageLink!),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                recipe.name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                recipe.description,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),

            // Ingredientes
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Ingredientes: \n${recipe.ingredients}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),

            // Pasos de la receta
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.steps.map((RecipeStep step) => Text('- ${step.description}')).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
