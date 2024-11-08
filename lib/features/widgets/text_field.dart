import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/dimensions.dart';

class DetailsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double hMargin;
  final double vMargin;
  final TextInputType keyboardType;
  final bool clickable;
  final Color borderColor;
  final Color activeBorderColor;
  final Color? fillColor;
  final Function? onTap;
  const DetailsTextField({
    required this.controller,
    required this.label,
    this.hMargin = 0.07,
    this.vMargin = 0.04,
    this.keyboardType = TextInputType.text,
    this.clickable = true,
    this.borderColor = const Color(0xff9EA1A8),
    this.activeBorderColor = primaryInnoColor,
    this.fillColor = const Color.fromARGB(255, 247, 247, 247),
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * hMargin,
        vertical: getScreenWidth(context) * vMargin,
      ),
      height: getScreenHeight(context)*0.068,
      child: TextField(
        onTap: ()=>onTap,
        cursorErrorColor: Colors.red,
        enabled: clickable,
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelStyle: GoogleFonts.sourceSans3(fontSize:14,color: const Color(0xff121A2C),fontWeight: FontWeight.w400),
            contentPadding: const EdgeInsets.fromLTRB(5.0 , 10.0 , 5.0 , 10.0),
            enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(12)),
            filled: false,
            labelText: label,
            fillColor: fillColor,
            floatingLabelStyle: const TextStyle(color: Colors.black45),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: activeBorderColor))),
      ),
    );
  }
}