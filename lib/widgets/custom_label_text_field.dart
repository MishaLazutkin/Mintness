import 'package:flutter/material.dart';

import '../style.dart';

class CustomLabelTextField extends StatefulWidget {
   TextStyle textStyle;
  final String label;

   CustomLabelTextField(
      {Key key,
      this.textStyle,

      this.label})
      : super(key: key);

  @override
  _CustomLabelTextFieldState createState() => _CustomLabelTextFieldState();
}

class _CustomLabelTextFieldState extends State<CustomLabelTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyle.label),
        ],
      ),
    );
  }
}
