import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mintness/style.dart';
import 'package:mintness/utils/constants.dart';
import 'package:mintness/widgets/other_widgets.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                children: [
                  _header(context),
                  SizedBox(
                    height: 40,
                  ),
                  _body()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _header(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            backButton(context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terms Of Service',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColor.primaryText.withOpacity(0.2)),
            )
          ],
        )
      ],
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terms Of Service',
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE1,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE2,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
 SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE3,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
 SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE4,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
 SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE5,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE6,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
SizedBox(
          height: 16,
        ),
        Text(
          AppConstants.TERMS_OF_SERVICE7,
          style: GoogleFonts.montserrat(textStyle:TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),

      ],
    );
  }
}
