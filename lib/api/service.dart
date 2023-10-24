import 'package:http/http.dart' as http;
import 'dart:convert';

/*class service{
  static Future<List<post>> getPost() async{
    final rspta = await http.get(Uri.parse("https://recipe-realm-web-services-production.up.railway.app/"));

    if(rspta.statusCode==200){
      final rsptaJson=json.decode(rspta.body);
      final todosPost=listPost.listaPost(rsptaJson);
      return todosPost;
    }
    return <post>[];
  }

}*/