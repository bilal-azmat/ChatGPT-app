abstract class ChatGptEvents{}

class FetchDataForChatGptEvent extends ChatGptEvents
{
  String inputData ;

  FetchDataForChatGptEvent({required this.inputData});
}

class MakeAnswerEmptyEvent extends ChatGptEvents
{
}