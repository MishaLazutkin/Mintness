import 'package:flutter/material.dart';

import '../../style.dart';

class TimerData {
  String currentSession = '00:00:00';
  double secondsCount = 00;
  double minutesCount = 00;
  double hoursCount = 00;
  double diffInSeconds = 0;
  int taskId;
  int subtaskId;
  TextStyle textStyle = AppTextStyle.pageTitle;
  Color timerIconColor = AppColor.primary;
  Color headerColor = AppColor.darkPageBackground;
  String description;

  TimerData(
      {this.timerIconColor,
      this.textStyle,
      this.headerColor,
      this.currentSession,
      this.secondsCount,
      this.minutesCount,
      this.hoursCount,
      this.taskId,
      this.subtaskId,
      this.description,
      this.diffInSeconds});
}
