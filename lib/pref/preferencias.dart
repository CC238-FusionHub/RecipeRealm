import 'package:shared_preferences/shared_preferences.dart';

class preferencias{
  SharedPreferences? preferencia;
  String token="";

  Future<SharedPreferences?> get preferences async{
    if(preferencia==null){
      preferencia=await SharedPreferences.getInstance();
      token=preferencia?.getString("token")??"";
    }
    return preferencia;
  }

  Future<preferencias> init() async{
    preferencia=await preferences;
    return this;
  }

  Future<void> guardarToken() async{
    await preferencia?.setString("token", token);
  }
}