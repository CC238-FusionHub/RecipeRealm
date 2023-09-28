package com.example.reciperealm

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface APIInterface {
    @POST("/api/v1/account/login")
    fun requestLogin(@Body requestModel: LoginRequestModel): Call<ResponseLoginClass>

    @POST("/api/v1/account/register")
    fun requestRegister(@Body requestModel: RegisterRequestModel): Call<ResponseLoginClass>
}