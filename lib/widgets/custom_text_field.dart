import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../style.dart';

@immutable
class CustomTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool showSuccess;
  final String labelText;
  final String hintText;
  final String errorText;
  final TextInputType keyboardType;
  final bool autofocus;
  final bool obscureText;
  final bool showErrorIcon;
  final Function onToggleObscurity;
  final Function onClearField;
  final Function onTyping;
  final List<TextInputFormatter> inputFormatters;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Icon suffixIcon;
  final Color fillColor;

  const CustomTextField({
    this.focusNode,
    this.controller,
    this.showSuccess = false,
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.autofocus = false,
    this.obscureText = false,
    this.showErrorIcon = true,
    this.inputFormatters,
    this.textStyle = AppTextStyle.textFieldText,
    this.hintStyle = AppTextStyle.textFieldHint,
    this.suffixIcon,
    this.onClearField,
    this.onTyping,
    this.fillColor = AppColor.textFieldFill,
    Key key,

  })  : onToggleObscurity = null,
        super(key: key);

  const CustomTextField.password({
    this.focusNode,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.autofocus = false,
    this.obscureText = false,
    this.showErrorIcon = true,
    this.onToggleObscurity,
    this.onClearField,
    this.inputFormatters,
    this.textStyle = AppTextStyle.textFieldText,
    this.hintStyle = AppTextStyle.textFieldHint,
    this.suffixIcon,
    this.onTyping,
    this.fillColor = AppColor.textFieldFill,
    Key key,
  })  : showSuccess = null,
        super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool get showError => (widget.errorText != null)&&(widget.errorText.isNotEmpty);

  void _focusNodeListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget?.focusNode?.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    widget?.focusNode?.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(widget.labelText, style: AppTextStyle.textFieldLabel),
        if (widget.labelText != null) const SizedBox(height: 7),
        Container(
          height: 40,
          child: Stack(
            children: [
              TextField(
                onChanged: (x) {
                  if (widget.onTyping != null) widget.onTyping(x);
                },
                focusNode: widget.focusNode,
                controller: widget.controller,
                style: widget.textStyle,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                autofocus: widget.autofocus,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  fillColor: widget.fillColor,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  counterText: '',
                  focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  enabledBorder: showError? const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color:  AppColor.error ,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))):const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color:  Colors.transparent ,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle,
                ),
              ),
              if (widget.onToggleObscurity != null) _obscurityToggle(),
              if (widget.onClearField != null) _clearIcon(),
              if (widget.obscureText == null && widget.showSuccess ?? false)
                _successIcon(),
              if (widget.showErrorIcon &&
                      widget.obscureText == null &&
                      showError ??
                  false)
                _errorIcon(),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          showError ? widget.errorText : '',
          style: AppTextStyle.textFieldError,
        ),
      ],
    );
  }

  Border _border() {
    if (showError) {
      return Border.all(color: AppColor.error, width: 2);
    } else if (widget.focusNode?.hasFocus ?? false) {
      return Border.all(color: AppColor.primary, width: 2);
    } else {
      return Border.all(color: AppColor.textFieldBorder, width: 2);
    }
  }

  Widget _obscurityToggle() {
    return Align(
      alignment: const Alignment(1, 0),
      child: GestureDetector(
        onTap: widget.onToggleObscurity,
        child: Container(
          padding:
              const EdgeInsets.only(right: 18, left: 12, top: 12, bottom: 12),
          child: widget.obscureText
              ? SvgPicture.asset(
                  'lib/assets/icons/show_password.svg',
                  color: Color.fromRGBO(0, 0, 0, 0.5),
            width: 25,
            height: 25,
                )
              : SvgPicture.asset(
                  'lib/assets/icons/show_password.svg',
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
        ),
      ),
    );
  }

  Widget _clearIcon() {
    return Align(
      alignment: const Alignment(1, 0),
      child: GestureDetector(
        onTap: widget.onClearField,
        child: Container(
            padding:
                const EdgeInsets.only(right: 18, left: 12, top: 12, bottom: 12),
            child: widget.controller.text.isEmpty
                ? Container()
                : Container(
                    margin: widget.onToggleObscurity != null
                        ? EdgeInsets.only(right: 25)
                        : EdgeInsets.only(right: 0),
                    child: RawMaterialButton(
                      constraints:
                          BoxConstraints(minWidth: 0.0, minHeight: 36.0),
                      fillColor: AppColor.backgroundClearButton,
                      child: SvgPicture.asset(
                        'lib/assets/icons/clear.svg',
                        width: 12,
                        height: 12,
                        color: widget.errorText == null
                            ? Colors.white
                            : AppColor.error,
                      ),
                      padding: EdgeInsets.all(3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: CircleBorder(),
                    ),
                  )),
      ),
    );
  }

  Widget _successIcon() {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(1, 0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(right: 18, top: 4, bottom: 4),
          child: SvgPicture.asset(
            'lib/assets/icons/checkmark.svg',
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }

  Widget _errorIcon() {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(1, 0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(right: 13, top: 4, bottom: 4),
          child: SvgPicture.asset(
            'lib/assets/icons/cross.svg',
          ),
        ),
      ),
    );
  }
}
