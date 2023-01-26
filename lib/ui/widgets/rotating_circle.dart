import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RotatingCircle extends StatelessWidget {
  const RotatingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitCircle(
      color: Colors.white,
      size: 70.0,
    ) ;
  }
}
