package com.example.reciperealm

data class ResponseLoginClass(
    val access_token:String?,
    val refresh_token:String?,
    val statusCode:Int?,
    val message:String?,
    val description:String?,
    val timestamp:String?
)
