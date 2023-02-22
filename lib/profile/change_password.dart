import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mintness/auth/terms_of_service.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/reg_exp.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';

import '../style.dart';
import 'package:swipedetector/swipedetector.dart';
@immutable
class ChangePassword extends StatefulWidget {
  const ChangePassword();

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with FullscreenLoaderMixin<ChangePassword> {

  final _passwordTextController = TextEditingController();
  final _retypePasswordTextController = TextEditingController();

  String _passwordError;
  String _retypePasswordError;

  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;
  bool _showPasswordSuccess = false;
  bool _showRetypePasswordSuccess = false;
  bool _isDisabledButton = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SwipeDetector(
        onSwipeRight: () {
          setState(() {
            Navigator.pop(context);
          });
        },
        child: Stack(
          children: [
            Platform.isIOS
                ? ScrollConfiguration(
                    behavior: CustomScrollBehavior(), child: _body())
                : _body(),
            if (showLoader) const FullscreenLoader(),
          ],
        ),
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
                  children: [
                    SizedBox(height: 80),
                    logo_title(context),
                    SizedBox(height: 47),
                    signin_title(context),
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

  Widget signin_title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Create New Password',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _authForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextItem('Password'),
        const SizedBox(height: 5),
        _passwordTextField(context),
        const SizedBox(height: 20),
        RichTextItem('Re-Type password'),
        const SizedBox(height: 5),
        _retypePasswordTextField(context),
      ],
    );
  }

  bool _isValidated() {
    final newPassword = _passwordTextController.text;
    final repeatPassword = _retypePasswordTextController.text;

    bool newPasswordIsValid = false;
    bool repeatPasswordIsValid = false;

    setState(() {
      newPasswordIsValid = passwordValidator.hasMatch(newPassword) ;
      if (newPasswordIsValid) {
        _passwordError = null;
      } else if (newPassword.contains(' ')) {
        _passwordError = 'Your passwords cannot start or end with a blank space';
      } else if (newPassword.length < 8) {
        _passwordError = 'Your new password must be at least 8 characters long';
      } else   if (newPassword.length < 8) {

      }else
      {
        _passwordError = null;
      }

      repeatPasswordIsValid = passwordValidator.hasMatch(repeatPassword);
      if (repeatPasswordIsValid) {
        if (newPassword != repeatPassword) {
          _retypePasswordError = 'Your passwords do not match. Try again';
          repeatPasswordIsValid = false;
        } else {
          _retypePasswordError = null;
        }
      } else if (repeatPassword.contains(' ')) {
        _retypePasswordError ='Your passwords cannot start or end with a blank space';

      } else if (repeatPassword.length < 8) {
        _retypePasswordError = 'Your new password must be at least 8 characters long';
      } else {
        _retypePasswordError = null;
      }
    });

    bool result = newPasswordIsValid &&
        repeatPasswordIsValid &&
        newPassword.isNotEmpty &&
        repeatPassword.isNotEmpty;

    return result;
  }
  //
  // bool validateByPattern(String password) {
  //   return pwCheck(password);
  // }
  // bool _isValidated() {
  //   final email = _passwordTextController.text;
  //   bool emailIsValid = false;
  //   emailIsValid = emailValidator.hasMatch(email);
  //   if (email.trim().isEmpty) {
  //     emailIsValid = false;
  //     _passwordError = 'Field is required';
  //   }else
  //   if(!emailIsValid) _passwordError = 'Please enter valid email';
  //   setState(() {});
  //   return emailIsValid;
  // }
  // bool pwCheck(pw) {
  //   var criteria = 0;
  //   if (pw.toUpperCase() != pw) {
  //     // has lower case letters
  //     criteria++;
  //   }
  //   print('criteria $criteria');    // 11111q@s
  //   if (pw.toLowerCase() != pw) {
  //     // has upper case letters
  //     criteria++;
  //   }
  //   print('criteria $criteria');
  //
  //   if (patternHasSpecialCharacters.hasMatch(pw) == true) {
  //     // has special characters
  //     criteria++;
  //   }
  //   print('criteria $criteria');
  //
  //   if (patternHasNumbers.hasMatch(pw) == true) {
  //     // has numbers
  //     criteria++;
  //   }
  //   print('criteria $criteria');
  //
  //
  //   return (criteria >= 3 && pw.length >= 8 );
  // }
  Widget _passwordTextField(BuildContext context) {
    return CustomTextField.password(
      onTyping:(value) =>  _typingValidate( ),
      controller: _passwordTextController,
      obscureText: _obscurePassword,
      hintText: 'New Password',
      textStyle:   AppTextStyle.textFieldHint ,
      errorText: _passwordError,
      onToggleObscurity: _changePasswordObscurity,
    );
  }

  Widget _retypePasswordTextField(BuildContext context) {
    return CustomTextField.password(
      onTyping: (value) =>  _typingValidate( ),
      controller: _retypePasswordTextController,
      obscureText: _obscureRetypePassword,
      hintText: 'Re-Type',
      textStyle:   AppTextStyle.textFieldHint ,
      errorText: _retypePasswordError,
      onToggleObscurity: _changeRetypePasswordObscurity,
    );
  }

  void _typingValidate() {
    setState(() {
      _passwordError = null;
      _retypePasswordError = null;
      _isDisabledButton = !_validateForButton();
    });
  }
  void _changePasswordObscurity() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _changeRetypePasswordObscurity() {
    setState(() => _obscureRetypePassword = !_obscureRetypePassword);
  }

  bool _validateForButton() {
    final newPassword = _passwordTextController.text;
    final repeatPassword = _retypePasswordTextController.text;

    bool newPasswordIsValid = false;
    bool repeatPasswordIsValid = false;

    setState(() {
      newPasswordIsValid = passwordValidator.hasMatch(newPassword);

      repeatPasswordIsValid = passwordValidator.hasMatch(repeatPassword);
      if (repeatPasswordIsValid) {
        if (newPassword != repeatPassword) {
          repeatPasswordIsValid = false;
        } else
          repeatPasswordIsValid = true;
      }
    });
    bool result = newPasswordIsValid &&
        repeatPasswordIsValid &&
        newPassword.isNotEmpty &&
        repeatPassword.isNotEmpty;
    setState(() {
      result ? {_isDisabledButton = false} : {_isDisabledButton = true};
    });
    return result;
  }

  Widget _continueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: CustomButton(
          text: 'Change Password',
          isDisabled: _isDisabledButton,
          onTap: () {
            if (_isValidated()) {
              _submit();
            }
          },
        ),
      ),
    );
  }

  Future<void> _submit( ) async {
    final newPassword = _passwordTextController.text;
    final result = await runWithLoader(() async {
       dynamic result = await Api().changePassword({'password':newPassword});
      return result;
    });
    if (result) {
      Navigator.pop(context);
    }
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
