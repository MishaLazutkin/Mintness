import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mintness/providers/auth_provider.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/reset_password_provider.dart';
import 'package:mintness/utils/reg_exp.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_label_text_field.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';

import 'package:provider/provider.dart';

import '../style.dart';

@immutable
class EnterPasswordPage extends StatefulWidget {
  var code;

  EnterPasswordPage(this.code);

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage>
    with FullscreenLoaderMixin<EnterPasswordPage> {
  final _passwordFocusNode = FocusNode();
  final _retypePasswordFocusNode = FocusNode();

  final _passwordTextController = TextEditingController();
  final _retypePasswordTextController = TextEditingController();

  String _passwordError;
  String _retypePasswordError;
  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;
  bool _isDisabledButton = true;

  //At least 8 characters,At least 3 of the following:1)Lower case letters(A-Z)
  // 2)Upper case letters(A-Z),3)Numbers(0-9) 4)Special characters (ex_!@#$%^&*)

  bool _validateButton() {
    final newPassword = _passwordTextController.text;
    final repeatPassword = _retypePasswordTextController.text;

    bool newPasswordIsValid = false;
    bool repeatPasswordIsValid = false;

    newPasswordIsValid = validateByCriterias(newPassword);
    repeatPasswordIsValid = validateByCriterias(repeatPassword);
    if (newPasswordIsValid) {
      _passwordError = null;
    } else if (newPassword.contains(' ')) {
      _passwordError = 'Your passwords cannot start or end with a blank space';
    } else if (newPassword.length < 8) {
      _passwordError = 'Your new password must be at least 8 characters long';
    } else
      _passwordError = 'Password is to weak.';

    if (newPassword.isEmpty) _passwordError = 'Inputs can not be blank.';

    if ((newPassword != repeatPassword) &&
        (newPassword.isNotEmpty && repeatPassword.isNotEmpty)) {
      _retypePasswordError = 'Passwords do not match.';
      repeatPasswordIsValid = false;
    } else if (repeatPassword.isEmpty) {
      _retypePasswordError = 'Inputs can not be blank.';
      repeatPasswordIsValid = false;
    } else
      _retypePasswordError = '';

    if (newPasswordIsValid && repeatPasswordIsValid) {
      _passwordError = '';
      _retypePasswordError = '';
    }


    bool result = newPasswordIsValid && repeatPasswordIsValid;
    return result;
  }

  bool pwCheck(String pw) {
    var criteria = 0;

    if (pw.toUpperCase() != pw) {
      // has lower case letters
      criteria++;
    }
    print('criteria $criteria'); // 11111q@s
    if (pw.toLowerCase() != pw) {
      // has upper case letters
      criteria++;
    }
    print('criteria $criteria');

    if (patternHasSpecialCharacters.hasMatch(pw) == true) {

      // has special characters
      criteria++;
    }
    print('criteria $criteria');

    if (patternHasNumbers.hasMatch(pw) == true) {
      // has numbers
      criteria++;
    }
    print('criteria $criteria');

    return (criteria >= 3 && pw.length >= 8);
  }

  bool validateByCriterias(String password) {
    return pwCheck(password);
  }

  bool _isValidated() {
    final newPassword = _passwordTextController.text;
    final repeatPassword = _retypePasswordTextController.text;

    bool newPasswordIsValid = false;
    bool repeatPasswordIsValid = false;

    setState(() {
      newPasswordIsValid = validateByCriterias(newPassword);
      repeatPasswordIsValid = validateByCriterias(repeatPassword);
      if (newPasswordIsValid) {
        _passwordError = null;
      } else if (newPassword.contains(' ')) {
        _passwordError =
            'Your passwords cannot start or end with a blank space';
      } else if (newPassword.length < 8) {
        _passwordError = 'Your new password must be at least 8 characters long';
      } else
        _passwordError = 'Password is to weak.';

      if (newPassword.isEmpty) _passwordError = 'Inputs can not be blank.';
      if (repeatPassword.length < 8)
        _retypePasswordError = 'Your new password must be at least 8 characters long';
      if ((newPassword != repeatPassword) &&
          (newPassword.isNotEmpty && repeatPassword.isNotEmpty)) {
        _retypePasswordError = 'Passwords do not match.';
       // repeatPasswordIsValid = false;
      } else if (repeatPassword.isEmpty) {
        _retypePasswordError = 'Inputs can not be blank.';
       // repeatPasswordIsValid = false;
      } else
        _retypePasswordError = '';




      if (newPasswordIsValid && repeatPasswordIsValid) {
        _passwordError = '';
        _retypePasswordError = '';
      }
    });
    print('newPasswordIsValid $newPasswordIsValid');
    print('repeatPasswordIsValid $repeatPasswordIsValid');

    bool result = newPasswordIsValid && repeatPasswordIsValid;
    return result;
  }

  _typingValidate(String text) {
    setState(() {
      _passwordError = '';
      _retypePasswordError = '';
    });
  }

  void _changePasswordObscurity() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _changeRetypePasswordObscurity() {
    setState(() => _obscureRetypePassword = !_obscureRetypePassword);
  }

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
          if (showLoader) const FullscreenLoader(),
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Consumer<HomeProvider>(
          builder: (_, __, child) {
            return Container(child: child);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      children: [
                        SizedBox(height: 80),
                        logo_title(context),
                        SizedBox(height: 47),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Create New Password',
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: Colors.black))),
                          ],
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),
                  _authForm(context),
                  SizedBox(
                    height: 35,
                  ),
                  _changePasswordButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authForm(BuildContext parentContext) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLabelTextField(label: 'Password'),
            const SizedBox(height: 5),
            _passwordTextField(context, provider),
            const SizedBox(height: 20),
            CustomLabelTextField(label: 'Re-Type password'),
            const SizedBox(height: 5),
            _retypePasswordTextField(context, provider),
          ],
        );
      },
    );
  }

  Widget _passwordTextField(BuildContext context, AuthProvider provider) {
    return CustomTextField.password(
      focusNode: _passwordFocusNode,
      controller: _passwordTextController,
      hintText: 'Password',
      errorText: _passwordError,
      obscureText: _obscurePassword,
      onTyping: (text) => _typingValidate(text),
      onToggleObscurity: _changePasswordObscurity,
    );
  }

  Widget _retypePasswordTextField(BuildContext context, AuthProvider provider) {
    return CustomTextField.password(
      focusNode: _retypePasswordFocusNode,
      controller: _retypePasswordTextController,
      hintText: 'Re-Type',
      errorText: _retypePasswordError,
      obscureText: _obscureRetypePassword,
      onTyping: (text) => _typingValidate(text),
      onToggleObscurity: _changeRetypePasswordObscurity,
    );
  }

  Widget _changePasswordButton(BuildContext context) {
    return Consumer<ResetPasswordProvider>(
        builder: (BuildContext context, ResetPasswordProvider provider, _) {
      return Hero(
        tag: 'AuthSubmitButton',
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: CustomButton(
              text: 'Create New Password',
              isDisabled: _validateButton() ? false : true,
              onTap: () {
                if (_isValidated()) {
                  _resetPassword(provider);
                }
              },
            ),
          ),
        ),
      );
    });
  }

  _resetPassword(ResetPasswordProvider provider) async {
    await runWithLoader(() async {
      bool success = await provider.resetPassword(
          widget.code, _retypePasswordTextController.text);
      if (success) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
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
