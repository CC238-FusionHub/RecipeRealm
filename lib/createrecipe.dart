import 'package:flutter/material.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';

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
    );
  }
}
