import 'dart:core';

final passwordValidator = RegExp(r"^[^ ]{8}[^ ]*$");
//final patternHasInvalidCharacters = RegExp(r'^[a-zA-Z0-9_\-!@?#%&$\*$]+$');
//final patternHasSpecialCharacters = RegExp(r'[-!@?#%&$\*]');
final patternHasSpecialCharacters = RegExp(r'[-!@?#%&$\*]');
final patternHasNumbers = RegExp(r'\d');
