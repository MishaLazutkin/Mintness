import 'package:flutter/material.dart';

import '../style.dart';
import 'custom_button.dart';


@immutable
class SubmitButton extends StatelessWidget {

  final String text;
  final Function onTap;
  final bool isDisabled;

  const SubmitButton({
    @required this.text,
    @required this.onTap,
    @required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'AuthEmail',
      child: Material(
        child: CustomButton(
          text: text,
          onTap: onTap,
          isDisabled: isDisabled,
        ),
      ),
    );
  }
}
