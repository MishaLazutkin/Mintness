import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mintness/providers/reset_password_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import '../style.dart';
import 'forgot_password_enter_password.dart';

class EnterCodePage extends StatefulWidget {
  EnterCodePage(this.email);

  final email;

  @override
  _EnterCodePageState createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage>
    with FullscreenLoaderMixin<EnterCodePage> {
  bool _invalidCode = false;
  String _code = '';
  Color _pinInputBackground = HexColor('#F5F7FB');
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  static const _channel = const MethodChannel('com.iowise.mintness/sms');
  bool _isDisabledButton = true;
  bool _codeIsAccepted = false;

  _navigateChangePassword(String code) {
    NavigationService()
        .push(context, Direction.fromRight, EnterPasswordPage(code));
  }

  void _sendCode() async {
    await runWithLoader(() {
      context.read<ResetPasswordProvider>().sendVerifyCode(widget.email);
    });
  }

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(nativeSmsMethodCallHandler);
    _sendCode();
  }

  Future<dynamic> nativeSmsMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "SMSReceived":
        _code = methodCall.arguments.toString().trim();
        print('_code $_code');
        textEditingController.text = _code;
        Future.delayed(Duration(milliseconds: 500), () {
          _verifyCode(textEditingController.text);
          textEditingController.text = '';
          setState(() {});
        });
        setState(() {});
        break;
      default:
        break;
    }
  }

  // Resend New Code
  _getNewCode() async {
    textEditingController.text = '';
    setState(() {
      _invalidCode = false;
      _pinInputBackground = HexColor('#F5F7FB');
    });
    await runWithLoader(() {
      context.read<ResetPasswordProvider>().sendVerifyCode(widget.email);
    });
  }

  Widget _header() {
    return SafeArea(
      child: Row(
        children: [
          backButton(context),
          Text(
            'Verification',
            style: AppTextStyle.pageTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: emptyAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: _header()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 64,
                      ),
                      Text('Verify Password',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Please enter digital code sent you.',
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(117, 117, 117, 1)))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        // onTap: () => setState(() {
                        //       _isActive = true;
                        //     }),
                        child: Pinput(
                          defaultPinTheme: PinTheme(
                            width: (MediaQuery.of(context).size.width - 32) / 6,
                            height: 66,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                            decoration: BoxDecoration(
                              color: _pinInputBackground,
                              border: Border.all(
                                  color: Color.fromRGBO(234, 239, 243, 1)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          length: 6,
                          onChanged: (v) {
                            if (v.length == 6) _verifyCode(v);
                          },
                          onTap: () => setState(() {
                            _invalidCode = false;
                            _pinInputBackground = HexColor('#F5F7FB');
                          }),
                          focusNode: _pinPutFocusNode,
                          controller: textEditingController,
                          // submittedFieldDecoration: _pinPutDecoration.copyWith(
                          //   borderRadius: BorderRadius.circular(16.0),
                          // ),
                          focusedPinTheme: PinTheme(
                            width: (MediaQuery.of(context).size.width - 32) / 6,
                            height: 66,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                            decoration: BoxDecoration(
                              color: _pinInputBackground,
                              border: Border.all(color: AppColor.primary),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          // followingFieldDecoration: _pinPutDecoration.copyWith(
                          //   borderRadius: BorderRadius.circular(16.0),
                          //),
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      !_invalidCode
                          ? Container()
                          : Text('Invalid verify code.Please try again!',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: HexColor('#F2453D')))),
                      SizedBox(
                        height: 50.0,
                      ),
                      _codeIsAccepted
                          ?_successVerifyButton(context):
                      _verifyButton(context),
                      SizedBox(
                        height: 34.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: _getNewCode,
                            child: Text('Resend New Code',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(128, 145, 164, 1),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (showLoader) const FullscreenLoader(),
    ]);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  _verifyCode(String code) async {
    if (code == null || code == "") return;
    _isDisabledButton = false;
    setState(() {
      _invalidCode = false;
      _codeIsAccepted = false;
      _pinInputBackground = HexColor('#F5F7FB');
    });

    await runWithLoader(() async {
      bool success =
          await context.read<ResetPasswordProvider>().verifyCode(code);
      if (success) {
        setState(() {
          _codeIsAccepted = true;
        });
        Future.delayed(Duration(milliseconds: 500), () {
          _navigateChangePassword(code);
        });

      } else
        setState(() {
          _invalidCode = true;
          _pinInputBackground = Color.fromRGBO(255, 0, 0, 0.1);
        });
    });

    setState(() {
      textEditingController.text = '';
      _isDisabledButton = true;
    });
  }

  Widget _verifyButton(BuildContext context) {
    return Consumer<ResetPasswordProvider>(
        builder: (BuildContext context, ResetPasswordProvider provider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: CustomButton(
          text: 'Verify',
          textStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          isDisabled: _isDisabledButton,
          onTap: () {
            if (_isValidated()) {
              _verifyCode(textEditingController.text);
            }
          },
        ),
      );
    });
  }

  Widget _successVerifyButton(BuildContext context) {
    return Consumer<ResetPasswordProvider>(
        builder: (BuildContext context, ResetPasswordProvider provider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: CustomButton(
          enabledColor: HexColor('#2196F3'),
          text: '✓',
          textStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          // isDisabled: _isDisabledButton,
          onTap: () {
            //  if (_isValidated()) {
            // }
          },
        ),
      );
    });
  }

  bool _isValidated() {
    return textEditingController.text.length == 6;
  }
}
