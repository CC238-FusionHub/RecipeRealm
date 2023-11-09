import 'package:flutter/material.dart';
import '../get_started_screen.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: (){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context){
              return const GetStartedScreen();
            }));
      },
      tooltip: 'Cerrar sesión',
      iconSize: 30, // Ajusta el tamaño del icono según tus preferencias
    );
  }
}