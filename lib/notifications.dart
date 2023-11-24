import 'package:flutter/material.dart';
import 'package:reciperealm/widgets/LogoutButton.dart';

class notifications extends StatefulWidget {
  final String token;
  const notifications({Key? key, required this.token}) : super(key: key);

  @override
  State<notifications> createState() => _notificationsState(token: token);
}

class _notificationsState extends State<notifications> {
  final String token;
  _notificationsState({required this.token});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications),
              SizedBox(width: 10),
              Text(
                "Notificaciones",
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
