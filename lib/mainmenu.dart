import 'package:flutter/material.dart';
import 'package:reciperealm/api/service.dart';
import 'package:reciperealm/notifications.dart';
import 'package:reciperealm/profile.dart';

import 'api/Recipe.dart';
import 'createrecipe.dart';

class mainmenu extends StatefulWidget {
  final String token;
  const mainmenu({Key? key, required this.token}) : super(key: key);

  @override
  State<mainmenu> createState() => _mainmenuState(token: token);
}

class _mainmenuState extends State<mainmenu> {
  final String token;
  _mainmenuState({required this.token});

  service myService = service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MENU",
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
      body: FutureBuilder<List<Recipe>>(
        // Specify the type of data you're expecting
        initialData: [],
        future: myService.getRecipes(token),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          // Handle the snapshot and build the list of items
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var receta = snapshot.data![index];
              return Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 250,
                            child: Column(
                              children: [
                                Text('ID: ${receta.id}'),
                              ],
                            ),
                          ),
                          //Image.network('${usuario.avatar}', width: 100, height: 70,)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFA2751D),
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home, size: 40,)),
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
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return profile(token: token); // Replace with your target widget
                  },
                ),
              );
            }, icon: Icon(Icons.person, color: Colors.white, size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz, color: Colors.white, size: 40,)),
          ],
        ),
      ),
    );
  }
}
