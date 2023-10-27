import 'dart:typed_data';
import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final Uint8List imageBytes;

  FullScreenImagePage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Compartir') {
                // TODO Código para compartir imagen
              } else if (result == 'Guardar') {
                // TODO Código para guardar imagen
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Compartir',
                child: Text('Compartir imagen'),
              ),
              const PopupMenuItem<String>(
                value: 'Guardar',
                child: Text('Guardar'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(imageBytes),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO Código para editar imagen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA2751D),
            ),
            child: const Text(
              'Editar',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}