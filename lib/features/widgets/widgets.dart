import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/dimensions.dart';
import '../../constants/fonts.dart';

openIconSnackBar(context, String text, Widget icon,int time) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Row(
      children: [
        icon,
        const SizedBox(width: 5,),
        Text(text)
      ],
    ),
    duration:  Duration(milliseconds: time),
  ));
}

openErrorSnackBar(context, String text) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(milliseconds: 2500),
  ));
}

class CustomButton extends StatelessWidget {
  final double radius;
  final double height;
  final double width;
  final double padding;
  final Color color;
  final String text;
  final Color textColor;
  const CustomButton({
    super.key,
    this.radius = 4,
    this.height = 0.056,
    this.width = 0.32,
    this.padding = 0,
    this.color = primaryInnoColor,
    this.textColor = Colors.white,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(getScreenWidth(context)*padding),
        height: getScreenHeight(context)*height,
        width: getScreenWidth(context)*width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
        child: SmallTextType(
          text: text,
          color: textColor,
        )
    );
  }
}