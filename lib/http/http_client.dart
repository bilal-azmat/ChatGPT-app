import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService
{
  static HttpService instance = HttpService._() ;
  HttpService._();


  Future<http.Response> postRequestWithAccessToken({required String endpoint,
  required Map<String,String> headers ,
  required Map<String,dynamic> body
  }) async

  {
    final response = await http.post(
      Uri.parse(endpoint) ,
      headers: headers,
      body: jsonEncode(body),
    ) ;

  return response ;
  }

}