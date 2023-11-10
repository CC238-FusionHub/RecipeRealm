import 'package:flutter/material.dart';
import 'package:reciperealm/api/RecipeDetailsService.dart';
import 'package:reciperealm/data/RecipeDetail.dart';
import 'package:reciperealm/data/Ingredient.dart';
import 'api/IngredientsService.dart';

class AddRecipeDetailsView extends StatefulWidget {
  final int recipeId;
  final String token;

  const AddRecipeDetailsView({Key? key, required this.recipeId, required this.token}) : super(key: key);

  @override
  _AddRecipeDetailsViewState createState() => _AddRecipeDetailsViewState();
}

class _AddRecipeDetailsViewState extends State<AddRecipeDetailsView> {
  final _formKey = GlobalKey<FormState>();
  List<RecipeDetail> details = [];
  IngredientService ingredientService = IngredientService();

  void _addRecipeDetail() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        details.add(RecipeDetail(
          recipeId: widget.recipeId,
          ingredient: Ingredient(name: ''),
          quantity: '0',
          unit: '',
        ));
      });
    }
  }

  Future<void> _saveAllDetails() async {
    try {
      for (var detail in details) {
        await RecipeDetailsService().addRecipeDetail(detail);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Todos los detalles de receta añadidos con éxito')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al añadir detalles de receta')));
    }
  }

  Widget _buildDetailForm(RecipeDetail detail, int index) {
    TextEditingController ingredientNameController = TextEditingController(text: detail.ingredient.name);

    return Column(
      children: [
        Autocomplete<Ingredient>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text == '') {
              return const Iterable<Ingredient>.empty();
            }
            try {
              return await ingredientService.findIngredientByName(textEditingValue.text, widget.token);
            } catch (_) {
              return const Iterable<Ingredient>.empty();
            }
          },
          onSelected: (Ingredient selection) {
            setState(() {
              detail.ingredient = selection;
              ingredientNameController.text = selection.name;
            });
          },
          fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: ingredientNameController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(labelText: 'Nombre del Ingrediente'),
              validator: (value) => value!.isEmpty ? 'Por favor ingresa un ingrediente' : null,
              onChanged: (value) {
                detail.ingredient.name = value;
              },
            );
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Ingredient> onSelected, Iterable<Ingredient> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Ingredient option = options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option.name),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        TextFormField(
          initialValue: detail.quantity,
          decoration: InputDecoration(labelText: 'Cantidad'),
          onChanged: (value) => setState(() => detail.quantity = value),
          validator: (value) => value!.isEmpty ? 'Por favor ingresa una cantidad' : null,
        ),
        TextFormField(
          initialValue: detail.unit,
          decoration: InputDecoration(labelText: 'Unidad'),
          onChanged: (value) => setState(() => detail.unit = value),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Detalles de Receta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          itemCount: details.length + 2, // +2 para el botón de añadir y guardar
          itemBuilder: (context, index) {
            if (index < details.length) {
              return _buildDetailForm(details[index], index);
            } else if (index == details.length) {
              return ElevatedButton(
                onPressed: _addRecipeDetail,
                child: Text('Añadir Nuevo Detalle'),
              );
            } else {
              return ElevatedButton(
                onPressed: _saveAllDetails,
                child: Text('Guardar Todos los Detalles'),
              );
            }
          },
        ),
      ),
    );
  }
}