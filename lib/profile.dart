import 'package:flutter/material.dart';
import 'package:reciperealm/api/service.dart';
import 'package:reciperealm/createrecipe.dart';
import 'package:reciperealm/mainmenu.dart';
import 'package:reciperealm/notifications.dart';

class profile extends StatefulWidget {
  final String token;
  const profile({Key? key, required this.token}) : super(key: key);

  @override
  State<profile> createState() => _profileState(token: token);
}

class _profileState extends State<profile> {
  final String token;
  _profileState({required this.token});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MI PERFIL",
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
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFA2751D),
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return mainmenu(token: token); // Replace with your target widget
                  },
                ),
              );}, icon: Icon(Icons.home, color: Colors.white, size: 40,)),
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return createrecipe(token: token); // Replace with your target widget
                  },
                ),
              );
            }, icon: Icon(Icons.content_paste, color: Colors.white, size: 40,)),
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return notifications(token: token); // Replace with your target widget
                  },
                ),
              );
            }, icon: Icon(Icons.email, color: Colors.white, size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.person, size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz, color: Colors.white, size: 40,)),
          ],
        ),
      ),
    );
  }
}
