import 'package:flutter/material.dart';

import '../../const/color_constants.dart';

class RoundButton extends StatelessWidget {

  final String title ;
  final VoidCallback onTap ;
  final double width ;
  final double height ;
  const RoundButton({
    Key? key, required this.title, required this.onTap, required this.width, required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: ColorConstants.blueColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(
            title.toString(),
            style: const TextStyle(
                fontSize: 25,
                color: ColorConstants.whiteColor
            ),
          ),
        ),
      ),
    );
  }
}