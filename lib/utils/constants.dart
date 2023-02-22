import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../style.dart';

class AppConstants {
  static const RESPONSE_STATUS_SUCCES = 'success';
  static const RESPONSE_STATUS_ERROR = 'error';
  static const RESPONSE_STATUS_WARNING = 'warning';
  static const ERROR_TOAST_TEXT = 'An error has occurred';
  static const ENTRY_SAVED_TOAST = 'Time succesfully added!';
  static const ENTRY_UPDATED_TOAST = 'Time succesfully updated!';
  static const TERMS_OF_SERVICE1 = 'Direct messages (DMs) are smaller conversations that happen outside of channels. '
      'They can be one-to-one, or include up to nine people. '
      'DMs work well for one-off conversations that don\'t require an entire channel of people to weigh in.';
  static const TERMS_OF_SERVICE2 = 'Click All DMs at the top of your left sidebar. If you don\'t see this option, click More to find it.';
  static const TERMS_OF_SERVICE3 = 'By default, your most recent conversations are listed below the Direct Messages header in your left sidebar.';
  static const TERMS_OF_SERVICE4 = 'Who can use this feature?';
  static const TERMS_OF_SERVICE5 = 'All members can start and send DMs.';
  static const TERMS_OF_SERVICE6 = 'Guests can send DMs, but they can only start them with people who are in the same channel(s)';
  static const TERMS_OF_SERVICE7 = 'Starting and sending DMs is just like writing any other messages in Mintness.'
      'You can use the Compose button to start a new conversation, or type messages in the message field from an existing DM.';
static var subtasksStatuses=[
  {'id':0,'name':'Active','color':   '#50C878' },{'id':1,'name':'Completed','color':'#00244A'}];


  static var boxShadowHeader =
      BoxShadow(color: Colors.grey, blurRadius: 7, spreadRadius: 2);

  static var boxShadowCard = BoxShadow(
    color: Colors.grey.withOpacity(.1),
    blurRadius: 15.0, // soften the shadow
    spreadRadius: 5.0, //extend the shadow
  );
}
