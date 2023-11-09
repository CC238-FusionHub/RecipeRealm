import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reciperealm/RootScreen.dart';
import 'package:reciperealm/generated/assets.dart';
import 'package:reciperealm/widgets/ImageEditDialog.dart';
import 'api/UserService.dart';
import 'data/UserDto.dart';

class EditProfile extends StatefulWidget {
  final String token;
  final UserService userService = UserService(
      "https://recipe-realm-web-services-production.up.railway.app");

  EditProfile({Key? key, required this.token}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<Map<String, dynamic>> _profileData;
  File? _profileImageFile;
  File? _bannerImageFile;
  Uint8List? _imageBytes;
  Uint8List? _bannerBytes;
  String? _currentLocation;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfileData();
    //_getCurrentLocation();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_birthDateController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null &&
        selectedDate != DateTime.tryParse(_birthDateController.text)) {
      final newDateValue = TextEditingValue(
        text: selectedDate.toLocal().toIso8601String().split('T')[0],
        selection:
            TextSelection.collapsed(offset: selectedDate.toString().length),
      );
      setState(() {
        _birthDateController.value = newDateValue;
      });
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _handleImageSelection(bool isProfileImage) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ImageEditDialog(
        onTakePhoto: () {
          Navigator.pop(context, ImageSource.camera);
        },
        onChooseExisting: () {
          Navigator.pop(context, ImageSource.gallery);
        },
      ),
    );

    if (result != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: result);
      if (image != null) {
        final File imageFile = File(image.path);
        setState(() {
          if (isProfileImage) {
            _profileImageFile = imageFile;
          } else {
            _bannerImageFile = imageFile;
          }
        });
      }
    }
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    final Map<String, dynamic> userProfile =
        await widget.userService.getLoggedInUserProfile(widget.token);

    _firstNameController.text = userProfile['firstName'] ?? '';
    _lastNameController.text = userProfile['lastName'] ?? '';
    _locationController.text = userProfile['location'] ?? '';
    _bioController.text = userProfile['bio'] ?? '';
    _birthDateController.text = userProfile['birthDate'] ?? '';

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

  void _handleProfileUpdate() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar perfil'),
          content: Text('¿Estás seguro de que quieres actualizar tu perfil?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm != null && confirm) {
      List<int>? profileImageBytes;
      List<int>? bannerImageBytes;

      if (_profileImageFile != null) {
        profileImageBytes = await _profileImageFile!.readAsBytes();
      } else if (_imageBytes != null) {
        profileImageBytes = _imageBytes;
      }

      if (_bannerImageFile != null) {
        bannerImageBytes = await _bannerImageFile!.readAsBytes();
      } else if (_bannerBytes != null) {
        bannerImageBytes = _bannerBytes;
      }

      final updatedUser = UserDto(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        location: _locationController.text,
        bio: _bioController.text,
        birthDate:
            DateTime.tryParse(_birthDateController.text) ?? DateTime.now(),
        profileImage: profileImageBytes,
        bannerImage: bannerImageBytes,
      );

      try {
        final Map<String, dynamic> updateResponse =
            await widget.userService.updateUserProfile(
          widget.token,
          updatedUser,
        );

        if (updateResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil actualizado con éxito')),
          );
          Navigator.of(context).pop(); // cierra EditProfile
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => RootScreen(
                      token: widget.token,
                    )),
          );
        } else {
          String errorMsg = updateResponse['error'] ?? 'Error desconocido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el perfil: $errorMsg')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDITAR PERFIL",
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
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _handleImageSelection(false),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _bannerImageFile != null
                                      ? FileImage(_bannerImageFile!)
                                      : (_bannerBytes != null
                                          ? MemoryImage(_bannerBytes!)
                                          : const AssetImage(
                                                  Assets.imgDefaultBannerImage)
                                              as ImageProvider<Object>),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 150,
                              color: Colors.black54,
                            ),
                            const Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _firstNameController,
                              decoration:
                                  const InputDecoration(labelText: 'Nombre'),
                            ),
                            TextFormField(
                              controller: _lastNameController,
                              decoration:
                                  const InputDecoration(labelText: 'Apellido'),
                            ),


                            TextFormField(
                              controller: _bioController,
                              decoration:
                                  const InputDecoration(labelText: 'Biografía'),
                              maxLines: null,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _birthDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Fecha de nacimiento',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _handleProfileUpdate,
                              child: const Text('Actualizar Perfil'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 15.0,
                    top: 100,
                    child: GestureDetector(
                      onTap: () => _handleImageSelection(true),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImageFile != null
                                ? FileImage(_profileImageFile!)
                                : (_imageBytes != null
                                    ? MemoryImage(_imageBytes!)
                                    : AssetImage(Assets.imgDefaultProfileImage)
                                        as ImageProvider<Object>),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No se pudo cargar el perfil'));
          }
        },
      ),
    );
  }
}
