import 'package:chatgpt/extensions/string_formatter.dart';
import 'package:flutter/material.dart';
import '../../const/color_constants.dart';
import '../../localdb/local_db.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {

  List<Chat> chatList=[];

  @override
  void initState()  {
    getChatHistory();
    // TODO: implement initState
    super.initState();
  }

  getChatHistory(){
    ChatDatabase.instance.readAllChat().then((value) {
      chatList=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await ChatDatabase.instance.deleteAllChat();
                  setState(() {

                  });
                  // chatList.clear();
                  // BlocProvider.of<ChatGptBloc>(context)
                  //     .add(MakeAnswerEmptyEvent());
                },
              )),
        ],
      ),
      body: FutureBuilder<List<Chat>>(
        future: ChatDatabase.instance.readAllChat(),
        builder: (context, snapshot) {

          if(snapshot.hasData) {
            chatList=snapshot.data!;
            if (chatList.isNotEmpty) {
              return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    var chat=chatList[index];
                    return
                      Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                          key: UniqueKey(),
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) async {
                    // Remove the item from the data source.

                    await ChatDatabase.instance.delete(chat.id!);
                    setState(()  {
                    });

                    // Then show a snackbar.
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${chat.id} dismissed')));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(color: Colors.red),
                      child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: chatList[index].question.length > 30
                                    ? MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.6
                                    : null,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    //color: ColorConstants.whiteColor
                                    color: Colors.green.shade500),
                                child: SelectableText(
                                  chatList[index].question.toString(),
                                  style: const TextStyle(
                                    // color: Colors.black,
                                      color: Colors.white,
                                      fontSize: 22),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // Icon(
                              //   Icons.person,
                              //   color: ColorConstants.whiteColor,
                              //   size: 30,
                              // ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/user.png')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          //width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   Icons.chat,
                                  //   color: ColorConstants.whiteColor,
                                  //   size: 30,
                                  // ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/ai.png')),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: chatList[index].answer.length > 30
                                        ? MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.6
                                        : null,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: ColorConstants.whiteColor),
                                    child: SelectableText(
                                      chatList[index].answer,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0,top: 8),
                                child: Text(chatList[index].dateTime.dateFormat(chatList[index].dateTime),style: const TextStyle(
                                    color: Colors.black
                                )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
                  }),
            );
            } else {
              return const Center(child: Text("No Chat History!",
            style: TextStyle(
              //fontWeight: FontWeight.w700,
              fontSize: 20
            ),
            ));
            }
          }
          return const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}
