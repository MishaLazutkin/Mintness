import 'package:flutter/material.dart';

import '../style.dart';

@immutable
class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isDisabled;
  final bool isOutlineStyle;
  final enabledColor;
  final Widget leading;
  final double height;

  final TextStyle textStyle;
  final disabledColor;

  final double cornerRadius;

  const CustomButton({
    @required this.text,
    @required this.onTap,
    this.isDisabled = false,
    this.enabledColor = AppColor.roundButtonEnabled,
    this.disabledColor = AppColor.roundButtonDisabled,
    this.cornerRadius = 8,
    this.leading,
    this.textStyle = AppTextStyle.roundButtonText, this.height = 50,
  }) : isOutlineStyle = false;

  const CustomButton.outline({
    @required this.text,
    @required this.onTap,
    this.isDisabled = false,
    this.enabledColor = AppColor.roundButtonEnabled,
    this.disabledColor = AppColor.roundButtonDisabled,
    this.cornerRadius = 8,
    this.leading,
    this.textStyle = AppTextStyle.roundButtonText, this.height =50,
  }) : isOutlineStyle = true;

  BoxDecoration _decoration() {
    if (isOutlineStyle) {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        border: Border.all(color: enabledColor, width: 2),
      );
    } else if (isDisabled) {
      return BoxDecoration(
        color: disabledColor,

        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      );
    } else {
      return BoxDecoration(
        color: enabledColor,
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: _decoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: leading,
                  ),
            Text(
              '${text}',
              textAlign: TextAlign.center,
              style: isOutlineStyle
                  ? AppTextStyle.roundButtonText.copyWith(color: enabledColor)
                  : textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
