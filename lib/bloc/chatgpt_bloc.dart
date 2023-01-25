import 'package:chatgpt/bloc/chatgpt_events.dart';
import 'package:chatgpt/bloc/chatgpt_states.dart';
import 'package:chatgpt/repositories/chatgpt_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localdb/local_db.dart';
import '../model/chatgpt_model.dart';

class ChatGptBloc extends Bloc<ChatGptEvents,ChatGptStates>
{
  ChatGptRepository chatGptRepository = ChatGptRepository() ;
  ChatGptModel? chatGptModel ;

  ChatGptBloc() : super(InitialState())
  {
    on<ChatGptEvents>((event, emit)
    async {
      if(event is FetchDataForLocalDbEvent)
      {
        emit(ChatGptInProgess()) ;

        try
        {
          List<Chat> chatList = await chatGptRepository.getChatFromLocalDB(inputData: event.inputData) ;

          if(chatList.isNotEmpty){
            print("data emitting from localDb in bloc");
            emit(ChatDBDataIsLoaded(chatGptModel: chatList)) ;
          }else{
            chatGptModel = await chatGptRepository.sendDataToChatGptRepository(inputData: event.inputData) ;
            print("data emitting from chat Gpt Api in bloc");
            emit(ChatGptIsLoaded(chatGptModel: chatGptModel!)) ;
          }
        }
        catch(e)
        {
          emit(ChatGptIsNotLoading(error: e.toString())) ;
        }
      }
      if(event is FetchDataForChatGptEvent)
      {
        emit(ChatGptInProgess()) ;

        try
        {
          chatGptModel = await chatGptRepository.sendDataToChatGptRepository(inputData: event.inputData) ;
          emit(ChatGptIsLoaded(chatGptModel: chatGptModel!)) ;
        }
        catch(e)
        {
          emit(ChatGptIsNotLoading(error: e.toString())) ;
        }
      }
      else if(event is MakeAnswerEmptyEvent)
      {
        emit(MakeAnswerEmptyState()) ;
      }
    }) ;
  }
}