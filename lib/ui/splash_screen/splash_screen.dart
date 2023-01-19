import 'dart:async';

import 'package:chatgpt/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:animated_rotating_widget/animated_rotating_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller ;

  @override
  void initState() {

    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3)
    ) ;

    controller.forward() ;
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: controller.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Icon(
                Icons.message_outlined,
                color: Colors.green,
                size: 200,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Welcome to Chat Gpt',
              style: TextStyle(fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade900),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose() ;
    // TODO: implement dispose
    super.dispose();
  }
}
