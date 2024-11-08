import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimensions.dart';

class SmallTextType extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextOverflow overflow;
  final TextAlign? textAlign;
  const SmallTextType({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.size = 16,
    this.weight = FontWeight.w600,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign
  });


  @override
  Widget build(BuildContext context) {
    double sizeV = getScreenWidth(context)*0.045;
    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign,
      style: GoogleFonts.sourceSans3(
        color: color,
        fontSize: (size==16)? sizeV:size,
        fontWeight: weight,
      ),
    );
  }
}