import 'package:flutter/material.dart';

class mainmenu extends StatefulWidget {
  const mainmenu({super.key});

  @override
  State<mainmenu> createState() => _mainmenuState();
}

class _mainmenuState extends State<mainmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
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
            IconButton(onPressed: (){}, icon: Icon(Icons.home, size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.content_paste,color: Colors.white,size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.email,color: Colors.white,size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.person,color: Colors.white,size: 40,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz,color: Colors.white,size: 40,)),
          ],
        )
      ),

    );
  }
}
