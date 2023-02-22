import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mintness/style.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({Key key, this.color, this.text}) : super(key: key);

  final String color;
  final text;

  @override
  Widget build(BuildContext context) {
     return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color==null||color=='#EDEDED'?HexColor(AppColor.primaryString):HexColor(color)),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 1.0,bottom: 1.0),
        child: Text('${text}',style:
        GoogleFonts.montserrat(textStyle: TextStyle(color:  color==null||color=='#EDEDED'?HexColor(AppColor.primaryString):HexColor(color),
          fontSize: 12,
          fontWeight: FontWeight.w500, ),)

        ),
      ),
    );
  }
}
