import 'package:flutter/material.dart';
import 'package:reciperealm/api/service.dart';
import 'package:reciperealm/mainmenu.dart';
import 'package:reciperealm/registerview.dart';
import 'package:reciperealm/pref/preferencias.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  preferencias pref=preferencias();
  final txtUsr=TextEditingController();
  final txtPass=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/img/logo.png')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: txtUsr,
                decoration: InputDecoration(
                    hintText: 'Ingrese email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: txtPass,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Ingrese contraseña',
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async{
                  final authService = service();
                  final result = await authService.authenticateUser(txtUsr.text, txtPass.text);
                  if (result != null && result['access_token']!="") {
                    pref.token=result['access_token']!;
                    pref.guardarToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return mainmenu(token: pref.token); // Replace with your target widget
                        },
                      ),
                    );
                  } else {
                    showDialog(context: context,
                        builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text('El usuario o contraseña son incorrectos'),
                      );
                      });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFA2751D),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Login",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ),)),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context){
                        return const registerview();
                      }));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  ).copyWith(
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                        return const BorderSide(
                          color: Color(0xFFA2751D),
                          width: 2.0,
                        );
                      },
                    ),
                  ),
                child: const Text("Registrarse",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA2751D),
                  ),)),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    pref.init();
  }
}
