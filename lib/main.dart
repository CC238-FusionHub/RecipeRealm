import 'package:flutter/material.dart';
import 'package:reciperealm/pref/preferencias.dart';

import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = preferencias(); // Create an instance of Preferencias
  await prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Realm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: login(),
    );
  }
}
