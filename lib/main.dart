import 'package:chatgpt/bloc/chatgpt_bloc.dart';
import 'package:chatgpt/ui/screens/home_screen.dart';
import 'package:chatgpt/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
      create: (BuildContext context) => ChatGptBloc(),
      child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      home: SplashScreen(),
    ) ;
  }
}