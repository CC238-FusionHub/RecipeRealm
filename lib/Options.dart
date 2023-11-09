import 'package:flutter/material.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';

class Options extends StatefulWidget {
  final String token;
  const Options({Key? key, required this.token}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState(token: token);
}

class _OptionsState extends State<Options> {
  final String token;
  _OptionsState({required this.token});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings),
              SizedBox(width: 10),
              Text(
                "Opciones",
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
