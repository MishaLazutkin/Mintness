import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:provider/provider.dart';

import '../style.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key key}) : super(key: key);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone>
    with FullscreenLoaderMixin<ChangePhone> {
  final _phoneFocusNode = FocusNode();
  final _phoneController = TextEditingController();
  var _isDisabledButton = true;

  final List<TextInputFormatter> _phoneInputFormatters = [
    MaskTextInputFormatter(
      mask: '#########',
      filter: {'#': RegExp(r'[0-9]')},
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppColor.darkPageBackground,
            body: Consumer<ProfileProvider>(
                builder: (_, ProfileProvider provider, __) {
              return SingleChildScrollView(
                  child: Container(child: _body(provider)));
            })),
        if (showLoader) const FullscreenLoader(showGrayBackground: false),
      ],
    );
  }

  Widget _body(ProfileProvider profileProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 54),
            _header(),
            const SizedBox(height: 30),
            _phoneTextField(),
            const SizedBox(height: 30),
            _continueButton(profileProvider)
          ],
        ),
      ),
    );
  }

  Widget _phoneTextField() {
    return Stack(
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7, left: 5.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Text(
                  '+380',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Flexible(
              child: CustomTextField(
                focusNode: _phoneFocusNode,
                textStyle: TextStyle(fontSize: 16, color: AppColor.primary),
                controller: _phoneController,
                inputFormatters: _phoneInputFormatters,
                fillColor: Colors.white,
                onClearField: _clearField,
                onTyping: (value) => _typingValidate(value),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _typingValidate(String value) {
    setState(() {
      _isDisabledButton = (value?.length ?? 0) < 1;
    });
  }

  _clearField() {
    setState(() {
      _phoneController.clear();
    });
  }

  Widget _continueButton(ProfileProvider profileProvider) {
    return Hero(
      tag: 'AuthSubmitButton',
      child: Material(
        child: CustomButton(
          text: 'Continue',
          isDisabled: _isDisabledButton,
          disabledColor: AppColor.secondary,
          onTap: () {
            if (!_isDisabledButton) {
              _updateProfile(profileProvider);
            }
          },
        ),
      ),
    );
  }

  _updateProfile(ProfileProvider profileProvider) async {
    await runWithLoader(() async {
      await profileProvider
          .updateProfile({'phone': '+380${_phoneController.text}'});
    });
    Navigator.pop(context);
  }

  Widget _header() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: Navigator.of(context).pop,
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: SvgPicture.asset(
                'lib/assets/icons/arrow_back.svg',
              ),
            ),
          ),
          Text(
            'Change Number',
            style: AppTextStyle.pageTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
