import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColor {
  // static Color primary = Color.fromRGBO(0, 36, 74, 1);
  static Color primary = HexColor('#00244A');
  static String primaryString = '#00244A';

  static Color secondary = Color.fromRGBO(0, 36, 74, 0.5);

  static Color lightPageBackground = HexColor('#F5F7FB');
  static Color darkPageBackground = HexColor('#E8EAEE');

  static Color backgroundPageBody = HexColor('#F5F7FB');

  static const flushbarSuccessBackground = Color.fromRGBO(237, 247, 240, 1.0);
  static const flushbarErrorBackground = Color.fromRGBO(253, 236, 239, 1.0);
  static Color backgroundPageHeader = Color.fromRGBO(232, 234, 238, 1);
  static Color profileBackground = HexColor('#E8EAEE');
  static const flushbarSuccessIcon = Color.fromRGBO(114, 204, 150, 1.0);
  static const flushbarErrorIcon = Color.fromRGBO(246, 104, 127, 1.0);
  static const primaryText = Color.fromRGBO(0, 36, 74, 1);
  static const secondaryText = Color.fromRGBO(117, 117, 117, 1.0);
  static const dateTimeText = Color.fromRGBO(144, 144, 144, 1.0);
  static const dashboardTitle = Color.fromRGBO(125, 125, 125, 1.0);
  static const textFieldLabel = Color.fromRGBO(0, 36, 74, 1);
  static const textFieldText = Color.fromRGBO(0, 0, 0, 0.5);
  static const error = Color.fromRGBO(178, 0, 17, 1.0);
  static const textFieldHint = Color.fromRGBO(117, 117, 117, 1.0);
  static const Color textFieldFill = Color.fromRGBO(0, 36, 74, 0.05);
  static const textFieldBorder = Color.fromRGBO(221, 221, 221, 1.0);
  static const link = Color.fromRGBO(25, 119, 243, 1);
  static const roundButtonEnabled = Color.fromRGBO(0, 36, 74, 1);
  static const switchActiveColor = Color.fromRGBO(0, 36, 74, 1);
  static const roundButtonDisabled = Color.fromRGBO(0, 36, 74, 0.25);
  static const titleColor = Color.fromRGBO(0, 36, 74, 1);
  static const labelColor = Color.fromRGBO(0, 36, 74, 0.5);
  static const buttonLogout = Color.fromRGBO(244, 67, 54, 1);
  static const backgroundChatMessage = Color.fromRGBO(0, 36, 74, 0.05);
  static Color backgroundDropDown = HexColor('#E8EAEE');
  static const Color backgroundTransparent = Color.fromRGBO(246, 246, 246, 1);
  static const Color backgroundClearButton = Color.fromRGBO(159, 170, 184, 1);
  static const Color backgroundTimerOnHeader = Color.fromRGBO(48, 148, 0, 1);
  static Color backgroundPercentIndicator = HexColor('#C4C4C4');
  static Color percentIndicator = HexColor('#4CAF50');
  static Color homeTabsTextColor = HexColor('#00244A');
  static Color subtasks = Color.fromRGBO(109, 109, 109, 1);

  static List<Map<String, dynamic>> usersPalette = [
    {'A': Color.fromRGBO(79, 29, 176, 1)},
    {'B': Color.fromRGBO(131, 0, 169, 1)},
    {'C': Color.fromRGBO(216, 0, 81, 1)},
    {'D': Color.fromRGBO(231, 45, 36, 1)},
    {'E': Color.fromRGBO(244, 65, 10, 1)},
    {'F': Color.fromRGBO(247, 134, 0, 1)},
    {'G': Color.fromRGBO(250, 181, 0, 1)},
    {'H': Color.fromRGBO(197, 217, 0, 1)},
    {'I': Color.fromRGBO(127, 186, 33, 1)},
    {'J': Color.fromRGBO(72, 165, 48, 1)},
    {'K': Color.fromRGBO(33, 133, 116, 1)},
    {'L': Color.fromRGBO(40, 174, 204, 1)},
    {'M': Color.fromRGBO(35, 126, 248, 1)},
    {'N': Color.fromRGBO(45, 56, 173, 1)},

    {'O': Color.fromRGBO(79, 29, 176, 1)},
    {'P': Color.fromRGBO(131, 0, 169, 1)},
    {'Q': Color.fromRGBO(216, 0, 81, 1)},
    {'R': Color.fromRGBO(231, 45, 36, 1)},
    {'S': Color.fromRGBO(244, 65, 10, 1)},
    {'T': Color.fromRGBO(247, 134, 0, 1)},
    {'U': Color.fromRGBO(250, 181, 0, 1)},
    {'V': Color.fromRGBO(197, 217, 0, 1)},
    {'W': Color.fromRGBO(127, 186, 33, 1)},
    {'X': Color.fromRGBO(72, 165, 48, 1)},
    {'Y': Color.fromRGBO(33, 133, 116, 1)},
    {'Z': Color.fromRGBO(40, 174, 204, 1)},

  ];
}

class AppFont {
  static const regular400 = "MontserratRegular";
  static const medium500 = "MontserratMedium";
  static const semiBold600 = "MontserratSemiBold";
  static const bold700 = "MontserratBold";
  static const SFProRegular = "SFProRegular";
}

class AppTextStyle {
  static const roundButtonText = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w600,
      decoration: TextDecoration.none
  );

  static TextStyle pageTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 20,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle pageTitleWhite = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle tabSelectedTitle = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle tabUnselectedTitle = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle cancelButton = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 16,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle pageBodyTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 16,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle recentTasksListViewTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle recentTasksListViewSubTitle = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle cardTitle = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle cardItem = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle calendarItem = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle timeItem = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.primaryText,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle commentTimeItem = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 13,
    color: Colors.black.withOpacity(0.5),
    fontWeight: FontWeight.w400,
  ));

  static TextStyle commentAuthorItem = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle commentTextItem = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle pageBodyItem = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 16,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle itemDropDown = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.labelColor,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle listTileTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(0, 36, 74, 1),
    fontWeight: FontWeight.w600,
  ));

  static TextStyle listTileSubtitle = GoogleFonts.roboto(
      textStyle: TextStyle(
    fontSize: 12,
    color: Color.fromRGBO(0, 36, 74, 1),
    fontWeight: FontWeight.w400,
  ));

  static TextStyle listTileSubtitleOpacity = GoogleFonts.roboto(
      textStyle: TextStyle(
    fontSize: 12,
    color: Color.fromRGBO(0, 36, 74, 1).withOpacity(0.5),
    fontWeight: FontWeight.w400,
  ));

  static TextStyle itemUserStatuses = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle homePageBodyItem = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.labelColor,
    fontWeight: FontWeight.w400,
  ));

  static var homePageCardTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle homePageCardPercent = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle projectStatus = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle label = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 12,
    color: AppColor.labelColor,
    fontWeight: FontWeight.w500,
  ));

  static TextStyle cardDate = GoogleFonts.heebo(
      textStyle: TextStyle(
    fontSize: 13,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    fontWeight: FontWeight.w400,
  ));

  static TextStyle pageSubTitle = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 24,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle dateTimeFields = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w400,
  ));

  static TextStyle dateTimeFieldsInactive = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: AppColor.titleColor,
    fontWeight: FontWeight.w200,
  ));

  static TextStyle profileName = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle buttonText = GoogleFonts.montserrat(
      textStyle: TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ));

  static TextStyle  profileItemTitle = TextStyle(
    fontSize: 14,
    color:   Colors.black.withOpacity(0.5),
    fontWeight: FontWeight.w500,
  );

  static TextStyle profileItemText = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const subtaskItem = TextStyle(
    fontSize: 14,
    color: AppColor.primaryText,
    fontWeight: FontWeight.w600,
  );

  static const pageLink = TextStyle(
    fontSize: 13,
    color: AppColor.link,
    fontWeight: FontWeight.w600,
  );

  static const textFieldLabel = TextStyle(
    fontSize: 12,
    fontFamily: AppFont.regular400,
    color: AppColor.primaryText,
    fontWeight: FontWeight.w600,
  );

  static const flushbar = TextStyle(
    fontSize: 14,
    color: AppColor.primaryText,
    height: 17.07 / 14.0,
    fontWeight: FontWeight.w600,
  );

  static const textFieldText = TextStyle(
    fontSize: 14,
    fontFamily: AppFont.regular400,
    color: AppColor.textFieldText,
    height: 17.07 / 14.0,
  );

  static const textFieldHint = TextStyle(
    fontSize: 14,
    fontFamily: AppFont.regular400,
    color: AppColor.textFieldHint,
    height: 17.07 / 14.0,
  );

  static const textFieldErrorText = TextStyle(
    fontSize: 14,
    fontFamily: AppFont.regular400,
    color: AppColor.error,
    height: 17.07 / 14.0,
  );

  static const textFieldError = TextStyle(
    fontSize: 11,
    fontFamily: AppFont.medium500,
    color: AppColor.error,
    height: 13.41 / 11.0,
  );
}
