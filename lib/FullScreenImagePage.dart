import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciperealm/api/UserService.dart';
import 'package:reciperealm/widgets/ImageEditDialog.dart';


class FullScreenImagePage extends StatefulWidget {
  final Uint8List imageBytes;
  final String token;
  final Function(Uint8List) onImageUpdate;

  const FullScreenImagePage({
    Key? key,
    required this.imageBytes,
    required this.token,
    required this.onImageUpdate,
  }) : super(key: key);


  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _currentImageBytes;

  @override
  void initState() {
    super.initState();
    _currentImageBytes = widget.imageBytes;
  }

  void _showEditMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageEditDialog(
          onTakePhoto: () => _takePhoto(),
          onChooseExisting: () => _chooseExistingPhoto(),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final File photoFile = File(photo.path);
        await _uploadProfileImage(photoFile);
      }
    } catch (e) {
      print('Error taking photo: $e');
      // TODO: Mostrar un mensaje de error al usuario
    }
    Navigator.pop(context);  // Cierra el diálogo
  }

  Future<void> _chooseExistingPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        final File photoFile = File(photo.path);
        await _uploadProfileImage(photoFile);
      }
    } catch (e) {
      print('Error choosing existing photo: $e');
      // TODO: Mostrar un mensaje de error al usuario
    }
    Navigator.pop(context);  // Cierra el diálogo
  }


  Future<void> _uploadProfileImage(File imageFile) async {
    final userService = UserService("https://recipe-realm-web-services-production.up.railway.app");
    try {
      final response = await userService.uploadProfileImage(widget.token, imageFile);
      final newImageBase64 = response['profileImage'];
      final newImageBytes = base64Decode(newImageBase64);
      setState(() {
        _currentImageBytes = newImageBytes;
      });
      widget.onImageUpdate(newImageBytes);
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar la imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          _currentImageBytes != null ? Image.memory(_currentImageBytes!) : Container(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showEditMenu(context);
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