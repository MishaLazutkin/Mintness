import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mintness/auth/auth_page_email.dart';
import 'package:mintness/home/home_page.dart';
import 'package:mintness/providers/auth_provider.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/rich_text.dart';
import 'package:provider/provider.dart';
import '../style.dart';

@immutable
class AuthPagePassword extends StatefulWidget {
  var email;

  AuthPagePassword(this.email);

  @override
  _AuthPagePasswordState createState() => _AuthPagePasswordState();
}

class _AuthPagePasswordState extends State<AuthPagePassword>
    with FullscreenLoaderMixin<AuthPagePassword> {
  final _passwordFocusNode = FocusNode();

  final _passwordTextController = TextEditingController();

  String _passwordError;
  bool _obscurePassword = true;
  bool _isDisabledButton = true;

  bool _switchValue=false;


  Future<void> _navigateToScreen1(BuildContext context) async {
     NavigationService().pushReplacement(
      context,
        AuthPageEmail(),
    );
  }

  _typingValidate() {
    setState(() {
      _passwordError = null;
      _isDisabledButton = !_isValidated();
    });
  }

  bool _isValidated() {
    final password = _passwordTextController.text;

    bool passwordIsValid = false;

    setState(() {
      if (password.isEmpty) {
        _passwordError = 'This field is required';
      } else {
        passwordIsValid = true;
        _passwordError = null;
      }
    });
    return passwordIsValid;
  }

  Future<void> _signIn(BuildContext context, AuthProvider provider) async {
    final email  = widget.email;
    final password =  _passwordTextController.text;
    final successfulSignedIn = await runWithLoader(() async {
      final successfulSignedIn = await provider.login(
          email: email, password: password,staySignedIn:_switchValue, context: context);
      if (successfulSignedIn) {
           await Future.wait([
             context.read<HomeProvider>().init(),
             context.read<ProfileProvider>().init(),
           ]);
      }
      return successfulSignedIn;
    });
    if (successfulSignedIn) {
        NavigationService().pushReplacement(context, const HomePage());
    } else {
      _isDisabledButton = false;
      toast('Authorization error',type:ToastTypes.error);
    }
  }

  void _changePasswordObscurity() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _body(),
          if (showLoader) const FullscreenLoader(),
        ],
      ),
    );
  }

  Widget _footer() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom==0?true:false,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 62),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Divider(
              height: 10,
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            InkWell(
              onTap:() =>  _navigateToScreen1(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sign in to a different account', style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
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
                          padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                          child: Column(
                            children: [
                              SizedBox(height: 80),
                              logo_title(context),
                              SizedBox(height: 47),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Enter Your Password',style:  AppTextStyle.pageSubTitle),
                                ],
                              ),
                              SizedBox(
                                  height: 30),
                              if(LocalStorage().getUserData(widget.email).name!=null) Column(
                                children: [
                                  ListTile(leading: userAvatar('${LocalStorage().getUserData(widget.email).avatarUrl}',
                                      null,LocalStorage().getUserData(widget.email).name??'User name',48,48),
                                    title: Text('${LocalStorage().getUserData(widget.email).name??'User name'}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                  subtitle: Text('${LocalStorage().getUserData(widget.email).position??'Position'}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0)
                                  ),
                                  SizedBox(
                                      height: 30),
                                ],
                              ),

                            ],
                          ),
                        ),
                        _authForm(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CupertinoSwitch(
                              activeColor: AppColor.switchActiveColor,
                              value: _switchValue,
                              onChanged: (value) {
                                setState(() {
                                  _switchValue = value;
                                });
                              },
                            ),
                            Text('Stay signed in')
                          ],
                        ),
                        SizedBox(height: 35,),
                        _signInButton(context),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _footer(),
      ],
    );
  }

  Widget _authForm(BuildContext parentContext) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichTextItem(  'Password'),
            const SizedBox(height: 5),
            _passwordTextField(context, provider),

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
      onTyping:(value) {
        _typingValidate( );
      },
      onToggleObscurity: _changePasswordObscurity,
    );
  }


  Widget _signInButton(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider provider, _) {
      return Hero(
        tag: 'AuthSubmitButton',
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: CustomButton(
              text: 'Sign in',
              isDisabled: _isDisabledButton,
              onTap: () {
                if (_isValidated()) {
                  _signIn(context, provider);
                }
              },
            ),
          ),
        ),
      );
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
