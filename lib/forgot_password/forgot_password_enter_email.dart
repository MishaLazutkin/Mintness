import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_label_text_field.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/other_widgets.dart';

import '../style.dart';
import 'enter_code.dart';
import 'forgot_password_enter_password.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordEmailPageState createState() => _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final _emailFocusNode = FocusNode();

  final _emailTextController = TextEditingController();

  String _emailError;
  bool _showEmailSuccess = false;
  bool _isDisabledButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Platform.isIOS
              ? ScrollConfiguration(
              behavior: CustomScrollBehavior(), child: _body())
              : _body(),

         // if (showLoader) const FullscreenLoader(),
        ],
      ),
    );
  }


  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 54),
                    _header(),
                    SizedBox(height: 80),
                    reset_password_title(context),
                    SizedBox(
                      height: 59,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: _authForm(context),
              ),
              const SizedBox(height: 30),
              _continueButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        backButton(context),
      ],
    );
  }
  Widget reset_password_title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Reset password',
          style: AppTextStyle.pageSubTitle,
        ),
      ],
    );
  }

  Widget _authForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelTextField(label: 'Email'),
        const SizedBox(height: 5),
        _emailTextField(context),
      ],
    );
  }

  _typingValidate(String value) {
    setState(() {
      _emailError = null;
      _isDisabledButton = !_isValidated();
    });
  }

  bool _isValidated() {
    final email = _emailTextController.text;

    bool emailIsValid = false;

    emailIsValid = EmailValidator.validate(email);

    return emailIsValid;
  }

  Widget _emailTextField(BuildContext context) {
    return CustomTextField(
      focusNode: _emailFocusNode,
      onTyping:(value)=> _typingValidate(value),
      controller: _emailTextController,
      showSuccess: _showEmailSuccess,
      hintText: 'Email',
      textStyle: _emailError == null
          ? AppTextStyle.textFieldHint
          : AppTextStyle.textFieldErrorText,
      errorText: _emailError,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _continueButton(BuildContext context) {
    return Hero(
      tag: 'AuthEmail',
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: CustomButton(
            text: 'Continue',
            isDisabled: _isDisabledButton,
            onTap: () {
              if (_isValidated()) {
                _navigateEnterPassword(context);
              }
            },
          ),
        ),
      ),
    );
  }

  _navigateEnterPassword(BuildContext context) {
    NavigationService().push(
      context,
      Direction.fromRight,
      EnterCodePage(_emailTextController.text),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) =>
      child;
}