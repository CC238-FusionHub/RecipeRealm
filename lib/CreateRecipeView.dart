import 'package:flutter/material.dart';
import 'package:reciperealm/mainmenu.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';
import 'package:reciperealm/api/RecipeService.dart';
import 'package:reciperealm/data/CreateRecipe.dart';

import 'data/RecipeSteps.dart';

class CreateRecipeView extends StatefulWidget {
  final String token;
  const CreateRecipeView({Key? key, required this.token}) : super(key: key);

  @override
  _CreateRecipeViewState createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<CreateRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();
  List<TextEditingController> _stepControllers = [TextEditingController()];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cookTimeController.dispose();
    _ingredientsController.dispose();
    _videoLinkController.dispose();
    _imageLinkController.dispose();
    _stepControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addNewStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _saveRecipe() async {
    final List<RecipeStep> steps = _stepControllers.map((controller) => RecipeStep(description: controller.text)).toList();
    final CreateRecipe newRecipe = CreateRecipe(
      name: _nameController.text,
      description: _descriptionController.text,
      ingredients: _ingredientsController.text,
      cookTime: _cookTimeController.text,
      steps: steps,
      videoLink: _videoLinkController.text,
      imageLink: _imageLinkController.text,
    );

    try {
      final CreateRecipe createdRecipe = await RecipeService().createRecipe(newRecipe, widget.token);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mainmenu(token: widget.token),  // Asegúrate de que MainMenu esté importado correctamente
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la receta: $e')));
    }
  }

  Widget _buildStepInput(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _stepControllers[index],
              decoration: InputDecoration(
                labelText: 'Paso ${index + 1}',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: () => _removeStep(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear receta"),
        actions: <Widget>[LogoutButton()],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la Receta'),
              validator: (value) => value!.isEmpty ? 'Por favor ingresa un nombre' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextFormField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredientes'),
              maxLines: null, // Hace que el campo sea expansible
            ),
            TextFormField(
              controller: _cookTimeController,
              decoration: InputDecoration(labelText: 'Tiempo de Cocción'),
            ),
            TextFormField(
              controller: _videoLinkController,
              decoration: InputDecoration(labelText: 'Enlace de Video'),
            ),
            TextFormField(
              controller: _imageLinkController,
              decoration: InputDecoration(labelText: 'Enlace de Imagen'),
            ),
            ...List.generate(_stepControllers.length, (index) => _buildStepInput(index)),
            TextButton(
              child: Text('+ Añadir Paso'),
              onPressed: _addNewStep,
            ),
            ElevatedButton(
              child: Text('Guardar Receta'),
              onPressed: _saveRecipe,
            ),
          ],
        ),
      ),
    );
  }
}