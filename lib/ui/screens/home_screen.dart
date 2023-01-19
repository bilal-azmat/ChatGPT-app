import 'dart:io';

import 'package:chatgpt/bloc/chatgpt_bloc.dart';
import 'package:chatgpt/bloc/chatgpt_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chatgpt_events.dart';
import '../../const/color_constants.dart';
import '../widgets/rotating_circle.dart';
import '../widgets/show_toast.dart';
import 'package:chatgpt/extensions/string_formatter.dart';

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

  late String setText ;
  late String getText ;


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
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     'Welcome to ChatGpt',
        //   ),
        //   //backgroundColor: Colors.blueGrey.shade300,
        //   centerTitle: true,
        // ),
        bottomNavigationBar: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<ChatGptBloc>(context).add(MakeAnswerEmptyEvent());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.blueColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        //topRight: Radius.circular(15)
                    )),
                width: MediaQuery.of(context).size.width * 0.495,
                height: 55,
                child: Center(
                  child: Text(
                    'Clear',
                    style:
                    TextStyle(fontSize: 25, color: ColorConstants.whiteColor),
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.010,
              decoration: BoxDecoration(
                color: Colors.white70
              ),
            ),
            GestureDetector(
              onTap: (){},
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.blueColor,
                    borderRadius: BorderRadius.only(
                        //topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))
                ),
                width: MediaQuery.of(context).size.width * 0.495,
                height: 55,
                child: Center(
                  child: Text(
                    'History',
                    style:
                    TextStyle(fontSize: 25, color: ColorConstants.whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: BlocBuilder<ChatGptBloc, ChatGptStates>(
                builder: (context, state) {
              return Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(children: [
                    welcomeToSearch(context),
                    searchInTextField(context, state),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: state is ChatGptInProgess
                            ? Center(
                                child: RotatingCircle(),
                              )
                            : state is ChatGptIsLoaded
                                ? chatBubbles(state)
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
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color:
                                                      ColorConstants.redColor),
                                            ),
                                            Icon(
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
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget chatBubbles(ChatGptIsLoaded state) {
    getText = state.chatGptModel.choices!.first!.text!.replaceCharacter('\n\n', '') ;
    // String resultText = state.chatGptModel.choices!.first!.text!.replaceCharacter('\n\n', '') ;
    // final sharedPref = await SharedPreferences.getInstance();
    // await sharedPref.setString('getText', resultText) ;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: setText.length>30? MediaQuery.of(context).size.width * 0.6 : null,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    //color: ColorConstants.whiteColor
                    color: Colors.green.shade500
                  ),
                  child: SelectableText(
                    setText.toString(),
                    style: TextStyle(
                     // color: Colors.black,
                      color: Colors.white,
                      fontSize: 22
                    ),
                  ),
                ),
                SizedBox(
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/user.png')
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            //width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/ai.png')
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: state.chatGptModel.choices!.first!.text!.replaceCharacter('\n\n', '').length>30?
                  MediaQuery.of(context).size.width * 0.6
                      : null,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: ColorConstants.whiteColor
                  ),
                  child: SelectableText(
                    getText,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget helpYouImage() {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
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
            style: TextStyle(fontSize: 20, color: ColorConstants.whiteColor),
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: ColorConstants.whiteColor,
                size: 30,
              ),
              suffixIcon: Visibility(
                visible: textFieldClearButton,
                child: IconButton(
                  onPressed: () {
                    textController.clear();
                    setState(() {
                      textFieldClearButton = false;
                    });
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: ColorConstants.whiteColor,
                    size: 30,
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.whiteColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.whiteColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.redColor),
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
              if (text.length > 3) {
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
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setText = textController.text ;
              });
              FocusManager.instance.primaryFocus?.unfocus();
              if (formKey.currentState!.validate()) {
                BlocProvider.of<ChatGptBloc>(context).add(
                    FetchDataForChatGptEvent(inputData: textController.text));
              }
            },
            child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorConstants.blueColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'search',
                    style: TextStyle(
                        fontSize: 25, color: ColorConstants.whiteColor),
                  ),
                ),),
          ),
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
            Text(
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
              icon: Icon(
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
