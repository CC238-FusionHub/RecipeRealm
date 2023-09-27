package com.example.reciperealm

import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.TextView

class RegisterView : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register_view)

        val txtCorreo: EditText =findViewById(R.id.txtRegCorreo)
        val txtPass: EditText =findViewById(R.id.txtRegPass)
        val txtNom: EditText =findViewById(R.id.txtRegNom)
        val txtApe: EditText =findViewById(R.id.txtRegApe)
        val txtMsg: TextView=findViewById(R.id.txtRegMsg)

        val btnRegistrar: Button =findViewById(R.id.btnRegRegistrar)
        val btnRegresar: Button =findViewById(R.id.btnRegCancelar)


        btnRegistrar.setOnClickListener(){
            val nom:String=txtNom.text.toString()
            val ape:String=txtApe.text.toString()
            val usu:String=txtCorreo.text.toString()
            val pass:String=txtPass.text.toString()
            if (nom === "" || ape === "" || usu === "" || pass === ""){
                txtMsg.text="Todos los campos son obligatorios"
            }else{
                // funcion para enviar el registro
                val intent= Intent(this, MainActivity::class.java)
                startActivity(intent)
            }
        }

        btnRegresar.setOnClickListener(){
            val intent= Intent(this, MainActivity::class.java)
            startActivity(intent)
        }
    }
}