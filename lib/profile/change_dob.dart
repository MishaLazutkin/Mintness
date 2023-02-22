import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/utils/reg_exp.dart';
import 'package:mintness/widgets/custom_button.dart';
import 'package:mintness/widgets/custom_text_field.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:provider/provider.dart';

import '../style.dart';

class ChangeDob extends StatefulWidget {
  const ChangeDob({Key key, this.dob}) : super(key: key);
final String dob;
  @override
  _ChangeDobState createState() => _ChangeDobState();
}

class _ChangeDobState extends State<ChangeDob>
    with FullscreenLoaderMixin<ChangeDob> {
  final _dobController = TextEditingController();
  var _isDisabledButton = false;


  @override
  void initState() {
    _dobController.text=widget.dob;
  }

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
            _dobTextField(profileProvider),
            const SizedBox(height: 30),
            _continueButton(profileProvider)
          ],
        ),
      ),
    );
  }

  Widget _dobTextField(ProfileProvider profileProvider) {
    return Stack(
      children: [
        Flexible(
          child: CustomTextField(
            textStyle: TextStyle(fontSize: 16, color: AppColor.primary),
            controller: _dobController,
            fillColor: Colors.white,

          ),
        ),
        InkWell(
          onTap:() async{
            DateTime date =await  profileProvider.openDatePicker(context,DateFormat().add_yMd().parse( (profileProvider.dob)));
            if(date!=null) {
              _dobController.text = DateFormat('MM/dd/yyyy').format(date);
              _validate(_dobController.text);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset('lib/assets/icons/calendar.svg' )),
          ),
        )
      ],
    );
  }


    _validate(String value) {
    setState(() {
      _isDisabledButton = !(value?.isNotEmpty??false);
    });
  }


  Widget _continueButton(ProfileProvider profileProvider) {
    return Hero(
      tag: 'AuthSubmitButton',
      child: Material(
        child: CustomButton(
          text: 'Continue',
          isDisabled: _isDisabledButton,
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
      runWithLoader(() async {
      await profileProvider
          .updateProfile({'dob': '${_dobController.text}'});
      Navigator.pop(context);
    });
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
            'Change DOB',
            style: AppTextStyle.pageTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
