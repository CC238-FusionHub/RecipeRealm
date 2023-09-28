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
import android.widget.Toast
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class RegisterView : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register_view)

        val retrofit=ServiceBuilder.buildService(APIInterface::class.java)

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

            val registerObj = RegisterRequestModel(nom,ape,usu,pass)

            retrofit.requestRegister(registerObj).enqueue(
                object: Callback<ResponseLoginClass> {
                    override fun onResponse(
                        call: Call<ResponseLoginClass>,
                        response: Response<ResponseLoginClass>
                    ) {
                        val responseBody = response.body()
                        if (responseBody != null) {
                            val access_token = responseBody.access_token
                            val refresh_token = responseBody.refresh_token
                            val sharedPreferences = getSharedPreferences("my_app_prefs", Context.MODE_PRIVATE)
                            val editor = sharedPreferences.edit()
                            editor.putString("access_token", access_token)
                            editor.putString("refresh_token", refresh_token)
                            editor.apply()
                            Toast.makeText(this@RegisterView,"success", Toast.LENGTH_SHORT).show()
                            txtMsg.text="Registro exitoso"
                            //TODO: pasar a la vista principal
                        }else{
                            txtCorreo.text.clear()
                            txtPass.text.clear()
                            txtApe.text.clear()
                            txtNom.text.clear()
                            txtMsg.text="Usuario o Pass incorrectos"
                        }
                    }
                    override fun onFailure(call: Call<ResponseLoginClass>, t: Throwable) {
                        txtCorreo.text.clear()
                        txtPass.text.clear()
                        txtApe.text.clear()
                        txtNom.text.clear()
                        txtMsg.text="Datos Incorrectos"
                    }

                }
            )
        }

        btnRegresar.setOnClickListener(){
            val intent= Intent(this, MainActivity::class.java)
            startActivity(intent)
        }
    }
}