import 'package:chatgpt/bloc/chatgpt_bloc.dart';
import 'package:chatgpt/model/chatgpt_model.dart';

abstract class ChatGptStates{}

class InitialState extends ChatGptStates{}

class ChatGptInProgess extends ChatGptStates{}

class ChatGptIsLoaded extends ChatGptStates
{
  ChatGptModel chatGptModel ;

  ChatGptIsLoaded({required this.chatGptModel});
}

class ChatGptIsNotLoading extends ChatGptStates
{
  String error ;

  ChatGptIsNotLoading({required this.error});
}

class MakeAnswerEmptyState extends ChatGptStates{}