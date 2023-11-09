import 'package:flutter/material.dart';

class ImageEditDialog extends StatelessWidget {
  final Function onTakePhoto;
  final Function onChooseExisting;

  ImageEditDialog({
    required this.onTakePhoto,
    required this.onChooseExisting,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Imagen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Tomar foto'),
            onTap: () => onTakePhoto(),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Elegir foto existente'),
            onTap: () => onChooseExisting(),
          ),
        ],
      ),
    );
  }
}