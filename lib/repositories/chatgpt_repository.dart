import 'package:chatgpt/services/chatgpt_service.dart';

import '../model/chatgpt_model.dart';

class ChatGptRepository
{
  ChatGptModel? chatGptModel ;
  ChatGptService chatGptService =  ChatGptService() ;
  Future<ChatGptModel> sendDataToChatGptRepository({required String inputData}) async
  {
    chatGptModel =  await chatGptService.sendDataToChatGptService(inputData: inputData) ;
    return chatGptModel! ;
  }
}