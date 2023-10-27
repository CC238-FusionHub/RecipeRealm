import 'package:flutter/material.dart';

class createrecipe extends StatefulWidget {
  final String token;
  const createrecipe({Key? key, required this.token}) : super(key: key);

  @override
  State<createrecipe> createState() => _createrecipeState(token: token);
}

class _createrecipeState extends State<createrecipe> {
  final String token;
  _createrecipeState({required this.token});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CREAR RECETA",
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
    );
  }
}
