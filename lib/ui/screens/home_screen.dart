import 'dart:io';
import 'package:chatgpt/bloc/chatgpt_bloc.dart';
import 'package:chatgpt/bloc/chatgpt_states.dart';
import 'package:chatgpt/localdb/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/chatgpt_events.dart';
import '../../const/color_constants.dart';
import '../widgets/rotating_circle.dart';
import '../widgets/show_toast.dart';
import 'package:chatgpt/extensions/string_formatter.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // myFocusNode = FocusScope.of(context) ;
  final textController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool textFieldClearButton = false;

  bool answerClearButton = false;

  bool isTextFieldVisible = false;

  bool isWelcomeVisible = true;

  bool back = false;
  int time = 0;
  int duration = 1000;

  late String setText;
  late String getText;

  List<Chat> chatList = [];


  int? idFromDb;
  String? question;
  String? answer;
  String? dateTime;

  @override
  Widget build(BuildContext context) {
    // FocusNode myFocusNode = FocusNode() ;
    // FocusScope myFocusScope = FocusScope.of(context) as FocusScope ;

    Future<bool> willPop() async {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (back && time >= now) {
        back = false;
        exit(0);
      } else {
        time = DateTime.now().millisecondsSinceEpoch + duration;
        back = true;
        ShowToast().showToast("Press again the button to exit");
      }
      return false;
    }

    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          elevation: 0,
          actions: [

            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChatHistoryScreen()

                    ));
                    // ChatHistoryScreen
                    // BlocProvider.of<ChatGptBloc>(context)
                    //     .add(MakeAnswerEmptyEvent());
                  },
                ))
          ],
        ),
       
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BlocConsumer<ChatGptBloc, ChatGptStates>(
                listener: (context, state) async {
              if (state is ChatGptIsLoaded) {
                print("data emitting from chatgpt in home screen listener");
                textController.clear();
                getText = state.chatGptModel.choices!.first!.text!
                    .replaceCharacter('\n\n', '');
                chatList.add(Chat(question: setText, answer: getText,dateTime: DateTime.now().toString()));
                Chat data = await ChatDatabase.instance
                    .create(Chat(question: setText, answer: getText,dateTime: DateTime.now().toString()));

                print(data);
              }
              if(state is ChatDBDataIsLoaded){
                print("data emitting from localDb in home screen listener");
                textController.clear();
                getText = state.chatGptModel.first.answer
                    .replaceCharacter('\n\n', '');
                chatList.add(Chat(question: state.chatGptModel.first.question, answer: getText,dateTime: state.chatGptModel.first.dateTime));
                //   idFromDb=chatFromLocalDB.first.id;
                //   question=chatFromLocalDB.first.question;
                //   answer=chatFromLocalDB.first.answer;
                //   dateTime=chatFromLocalDB.first.dateTime;
              }
            }, builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 80),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: state is ChatGptInProgess
                        ? const Center(
                            child: RotatingCircle(),
                          )
                        : state is ChatGptIsLoaded || state is ChatDBDataIsLoaded
                            ? chatBubbles()
                            : state is ChatGptIsNotLoading
                                ? SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.error.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: ColorConstants.redColor),
                                        ),
                                        const Icon(
                                          Icons
                                              .signal_wifi_connected_no_internet_4_sharp,
                                          size: 50,
                                          color: ColorConstants.redColor,
                                        ),
                                      ],
                                    ),
                                  )
                                : state is MakeAnswerEmptyState
                                    ? helpYouImage()
                                    : helpYouImage(),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column(
                            //   children: [
                            //     Align(
                            //       alignment: Alignment.topRight,
                            //       child: IconButton(icon: Icon(Icons.clear,color: Colors.white,),onPressed: (){
                            //         BlocProvider.of<ChatGptBloc>(context)
                            //             .add(MakeAnswerEmptyEvent());
                            //       },)
                            //
                            //     ),
                            //     Align(
                            //       alignment: Alignment.topRight,
                            //       child: IconButton(icon: Icon(Icons.history,color: Colors.white,),onPressed: (){
                            //         BlocProvider.of<ChatGptBloc>(context)
                            //             .add(MakeAnswerEmptyEvent());
                            //       },)
                            //
                            //     ),
                            //   ],
                            // ),
                            welcomeToSearch(context),
                            searchInTextField(context, state),

                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: RoundButton(
                            //       title: 'Clear',
                            //       onTap: () {
                            //         BlocProvider.of<ChatGptBloc>(context)
                            //             .add(MakeAnswerEmptyEvent());
                            //       },
                            //       width: 100, height: 45,),
                            // ),
                          ]),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget chatBubbles() {

    return chatList.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return Column(
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
                                  ? MediaQuery.of(context).size.width * 0.6
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
                                      ? MediaQuery.of(context).size.width * 0.6
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
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
                      ),

                    ],
                  );
                }),
          )
        : const SizedBox();
  }

  Widget helpYouImage() {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.9,
            image: AssetImage('assets/help_you.png'),
          ),
        ),
      ),
    );
  }

  Widget searchInTextField(BuildContext context, ChatGptStates state) {
    return Visibility(
      visible: isTextFieldVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            //maxLength: 128,
            style: const TextStyle(fontSize: 20, color: ColorConstants.whiteColor),
            controller: textController,

            decoration: InputDecoration(
              hintText: "How May I Help You?",
              hintStyle:
                  const TextStyle(fontSize: 20, color: ColorConstants.whiteColor),

              // prefixIcon: Icon(
              //   Icons.search,
              //   color: ColorConstants.whiteColor,
              //   size: 30,
              // ),
              suffixIcon: Visibility(
                visible: textFieldClearButton,
                child: IconButton(
                  onPressed: () async {
                    // textController.clear();
                    // setState(() {
                    //   textFieldClearButton = false;
                    // });

                    setState(() {
                      setText = textController.text;
                    });

                    FocusManager.instance.primaryFocus?.unfocus();
                    if (formKey.currentState!.validate()) {
                      // List<Chat> chatFromLocalDB= await ChatDatabase.instance.getChatFromDB(textController.text);
                      // print("scscsd");
                      // print(chatFromLocalDB.length);
                      // if(chatFromLocalDB.isNotEmpty){
                      //
                      //   idFromDb=chatFromLocalDB.first.id;
                      //   question=chatFromLocalDB.first.question;
                      //   answer=chatFromLocalDB.first.answer;
                      //   dateTime=chatFromLocalDB.first.dateTime;

                        BlocProvider.of<ChatGptBloc>(context).add(
                            FetchDataForLocalDbEvent(
                                inputData: textController.text));







                      // }else {
                      //   BlocProvider.of<ChatGptBloc>(context).add(
                      //       FetchDataForChatGptEvent(
                      //           inputData: textController.text));
                      // }
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: ColorConstants.whiteColor,
                    size: 30,
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.whiteColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.whiteColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.redColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (String? text) {
              if (text!.isEmpty) {
                return 'Enter the characters';
              } else {
                return null;
              }
            },
            onChanged: (text) {
              if (text.length > 1) {
                setState(() {
                  textFieldClearButton = true;
                });
              } else {
                setState(() {
                  textFieldClearButton = false;
                });
              }
            },
          ),
          const SizedBox(
            height: 5,
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       setText = textController.text ;
          //     });
          //     FocusManager.instance.primaryFocus?.unfocus();
          //     if (formKey.currentState!.validate()) {
          //       BlocProvider.of<ChatGptBloc>(context).add(
          //           FetchDataForChatGptEvent(inputData: textController.text));
          //     }
          //   },
          //   child: Container(
          //       height: 50,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //           color: ColorConstants.blueColor,
          //           borderRadius: BorderRadius.circular(10)),
          //       child: Center(
          //         child: Text(
          //           'search',
          //           style: TextStyle(
          //               fontSize: 25, color: ColorConstants.whiteColor),
          //         ),
          //       ),),
          // ),
        ],
      ),
    );
  }

  Widget welcomeToSearch(BuildContext context) {
    return Visibility(
      visible: isWelcomeVisible,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Chat Gpt',
              style: TextStyle(fontSize: 25, color: ColorConstants.whiteColor),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isTextFieldVisible = true;
                  isWelcomeVisible = false;
                });
              },
              icon: const Icon(
                Icons.search,
                color: ColorConstants.whiteColor,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
