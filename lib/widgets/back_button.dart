import 'package:flutter/material.dart';

class AppBackButton extends StatefulWidget {
  final Color arrowColor;
  final Color backgroundColor;
  final Map<String, dynamic> onBackArguments;

  const AppBackButton(
      {this.arrowColor, this.backgroundColor, this.onBackArguments});

  @override
  _AppBackButtonState createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.all(
              Radius.circular(15.0) //                 <--- border radius here
          ),
        ),
        child: Center(
            child: IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: widget.arrowColor,
                ),
                onPressed: () =>
                widget.onBackArguments != null ? Navigator.of(context).pop(
                    widget.onBackArguments):Navigator.of(context).pop()),)
    ,
    );
  }
}