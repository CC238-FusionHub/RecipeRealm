package com.example.reciperealm

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val retrofit=ServiceBuilder.buildService(APIInterface::class.java)

        val txtCorreo: EditText =findViewById(R.id.txtCorreo)
        val txtPass: EditText =findViewById(R.id.txtPass)
        val btnIniciar: Button =findViewById(R.id.btnIniciar)
        val btnRegistrar: Button =findViewById(R.id.btnRegistrar)
        val txtMsg: TextView=findViewById(R.id.txtMsg)

        btnIniciar.setOnClickListener(){
            val usu:String=txtCorreo.text.toString()
            val pass:String=txtPass.text.toString()


            val loginObj = LoginRequestModel(usu,pass)

            retrofit.requestLogin(loginObj).enqueue(
                object: Callback<ResponseLoginClass>{
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
                            Toast.makeText(this@MainActivity,"success",Toast.LENGTH_SHORT).show()
                            txtMsg.text="Login exitoso"
                            //TODO: mover a la vista principal
                        }else{
                            txtCorreo.text.clear()
                            txtPass.text.clear()
                            txtMsg.text="Usuario o Pass incorrectos"
                        }
                    }
                    override fun onFailure(call: Call<ResponseLoginClass>, t: Throwable) {
                        txtCorreo.text.clear()
                        txtPass.text.clear()
                        txtMsg.text="Usuario o Pass incorrectos"
                    }

                }
            )
        }

        btnRegistrar.setOnClickListener(){
            val intent= Intent(this, RegisterView::class.java)
            startActivity(intent)
        }
    }
}