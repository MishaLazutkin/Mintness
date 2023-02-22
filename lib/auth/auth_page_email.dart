import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mintness/auth/terms_of_service.dart';
import 'package:mintness/forgot_password/forgot_password_enter_email.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../style.dart';
import 'auth_page_password.dart';

@immutable
class AuthPageEmail extends StatefulWidget {
  const AuthPageEmail();

  @override
  _AuthPageEmailState createState() => _AuthPageEmailState();
}

class _AuthPageEmailState extends State<AuthPageEmail>
    with FullscreenLoaderMixin<AuthPageEmail> {
  final _emailFocusNode = FocusNode();

  final _emailTextController = TextEditingController();

  String _emailError;
  bool _showEmailSuccess = false;
  bool _isDisabledButton = true;


  Future<void> _navigateToForgotPasswordPage(BuildContext context) async {
    NavigationService().push(
      context,
      Direction.fromRight,  ForgotPasswordEmailPage( ),
    );
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
          _terms_of_service(),
          if (showLoader) const FullscreenLoader(),
        ],
      ),
    );
  }

  Widget _terms_of_service() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom==0?true:false,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 62),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _forgotPasswordButton(context),
            Divider(
              height: 10,
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap:()=> _navigateTermsOfService(context),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Protected by and subject to the ',
                    ),
                    TextSpan(
                        text: 'Mintness Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return Align(
      alignment: const Alignment(1, 0),
      child: GestureDetector(
        onTap: () => _navigateToForgotPasswordPage(context),
        child: Consumer<HomeProvider>(
          builder: (_, __, ___) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Reset password',
                  style: AppTextStyle.pageLink,
                ),
              ],
            );
          },
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
          'Sign in',
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
        RichTextItem('Email'),
        const SizedBox(height: 5),
        _emailTextField(context),
      ],
    );
  }

  _typingValidate(String email) {
    setState(() {
      _emailError = null;
      _isDisabledButton = !EmailValidator.validate(email);
    });
  }

  bool _isValidated() {
    final email = _emailTextController.text;
    bool emailIsValid = false;
    emailIsValid = EmailValidator.validate( email);
    if (email.trim().isEmpty) {
      emailIsValid = false;
      _emailError = 'Field is required';
    }else
    if(!emailIsValid) _emailError = 'Please enter valid email';
    setState(() {});
    return emailIsValid;
  }

  Widget _emailTextField(BuildContext context) {
    return CustomTextField(
      focusNode: _emailFocusNode,
      onTyping:(value) {
        _typingValidate( value);
      },
      controller: _emailTextController,
      showSuccess: _showEmailSuccess,
      hintText: 'Email',
      textStyle:   AppTextStyle.textFieldHint ,
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
      AuthPagePassword(_emailTextController.text),
    );
  }

  _navigateTermsOfService(BuildContext context) {
    NavigationService().push(
      context,
      Direction.fromBottom,
      TermsOfService(),
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
