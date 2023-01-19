import 'dart:convert';
import 'dart:io';

import 'package:chatgpt/http/http_client.dart';
import 'package:chatgpt/model/chatgpt_model.dart';

import '../const/api_constants.dart';

class ChatGptService
{

  Future<ChatGptModel> sendDataToChatGptService({required String inputData}) async
  {
    final response = await HttpService.instance.postRequestWithAccessToken(
        endpoint: ApiConstants.chatGptApi,
        headers: <String,String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConstants.token}'
        },
        body: <String,dynamic>{
          "model": "text-davinci-003",
            "prompt": inputData,
            "max_tokens": 4000,
            "temperature": 0
        },
    ) ;

    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body) ;
      return ChatGptModel.fromJson(data) ;
    }
    else
    {
      print('The status code is : ${response.statusCode}') ;
      throw Exception('Something went wrong') ;
    }
  }
}