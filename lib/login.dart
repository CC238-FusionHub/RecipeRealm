import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
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
              child: Container(
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
                    hintText: 'Ingrese nombre de usuario',
                    labelText: 'Usuario',
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
                onPressed: (){
                  setState(() {
                  });
                },
                child: Text("Login",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),)),
            SizedBox(height: 20,),
            /*Text('Subtotal: $subt',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),*/
          ],
        ),
      ),
    );
  }
}
