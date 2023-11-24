import 'package:flutter/material.dart';
import 'package:reciperealm/api/service.dart';

class registerview extends StatefulWidget {
  const registerview({super.key});

  @override
  State<registerview> createState() => _registerviewState();
}

class _registerviewState extends State<registerview> {

  final txtfirstName=TextEditingController();
  final txtlastName=TextEditingController();
  final txtemail=TextEditingController();
  final txtpassword=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRO",
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: txtfirstName,
                decoration: InputDecoration(
                    hintText: 'Ingrese nombres',
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: txtlastName,
                decoration: InputDecoration(
                    hintText: 'Ingrese apellidos',
                    labelText: 'Apellido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: txtemail,
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
                controller: txtpassword,
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
                  final result = await authService.registerUser(txtfirstName.text, txtlastName.text, txtemail.text, txtpassword.text);

                  if (result != null && result['access_token']!="") {
                    Navigator.pop(context);
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Success"),
                            content: Text('Usuario creado con exito'),
                          );
                        });
                  } else {
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Authentication Failed"),
                            content: Text('Error en el registro'),
                          );
                        });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFA2751D),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Registrarse",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),)),
          ],
        ),
      ),

    );
  }
}
