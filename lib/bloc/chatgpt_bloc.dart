import 'package:chatgpt/bloc/chatgpt_events.dart';
import 'package:chatgpt/bloc/chatgpt_states.dart';
import 'package:chatgpt/repositories/chatgpt_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/chatgpt_model.dart';

class ChatGptBloc extends Bloc<ChatGptEvents,ChatGptStates>
{
  ChatGptRepository chatGptRepository = ChatGptRepository() ;
  ChatGptModel? chatGptModel ;

  ChatGptBloc() : super(InitialState())
  {
    on<ChatGptEvents>((event, emit)
    async {
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