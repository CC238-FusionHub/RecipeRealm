package com.example.reciperealm

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.TextView

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val txtCorreo: EditText =findViewById(R.id.txtCorreo)
        val txtPass: EditText =findViewById(R.id.txtPass)
        val btnIniciar: Button =findViewById(R.id.btnIniciar)
        val btnRegistrar: Button =findViewById(R.id.btnRegistrar)
        val chkRecordar: CheckBox=findViewById(R.id.chkRecordar)
        val txtMsg: TextView=findViewById(R.id.txtMsg)

        val pref: SharedPreferences =this.getSharedPreferences("pref1", Context.MODE_PRIVATE)
        val check:Boolean=pref.getBoolean("chk",false)
        val usu:String=pref.getString("usu","")!!
        val pass:String=pref.getString("pass","")!!

        if(check){
            txtCorreo.setText(usu)
            txtPass.setText(pass)
            chkRecordar.isChecked=true
        }else{
            txtCorreo.setText(usu)
            txtPass.setText(pass)
            chkRecordar.isChecked=false
        }

        btnIniciar.setOnClickListener(){
            val usu:String=txtCorreo.text.toString()
            val pass:String=txtPass.text.toString()

            val editor:SharedPreferences.Editor=pref.edit()
            if(usu == "upc@upc.pe" && pass== "upc"){
                if(chkRecordar.isChecked){
                    editor.putString("usu",usu)
                    editor.putString("pass",pass)
                    editor.putBoolean("chk",true)
                }else{
                    editor.putString("usu","")
                    editor.putString("pass","")
                    editor.putBoolean("chk",false)
                }
                editor.apply()
                editor.commit()

                //cambiar a la pagina principal
                //val intent= Intent(this, MainActivity2::class.java)
                //startActivity(intent)
            }else{
                txtCorreo.text.clear()
                txtPass.text.clear()
                txtMsg.text="Usuario o Pass incorrectos"
            }
        }

        btnRegistrar.setOnClickListener(){
            val intent= Intent(this, RegisterView::class.java)
            startActivity(intent)
        }
    }
}