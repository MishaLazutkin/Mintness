import 'package:flutter/services.dart';

List<TextInputFormatter> textFieldFormatters({
  int maxLength,
  RegExp whitelistRegExp,
  bool removeSpaces = false,
}) {
  return [
    if (maxLength != null) _textLengthFormatter(maxLength, removeSpaces),
    if (whitelistRegExp != null) _whitelistRegExpFormatter(whitelistRegExp),
  ];
}

TextInputFormatter _textLengthFormatter(int maxLength, [bool removeSpaces = false]) {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    final comparedValue = removeSpaces
      ? newValue.text.replaceAll(' ', '')
      : newValue.text;
    if (comparedValue.length <= maxLength) {
      return newValue;
    } else {
      return _oldTextEditingValue(oldValue);
    }
  });
}

TextInputFormatter _whitelistRegExpFormatter(RegExp whitelistRegExp) {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    if (!whitelistRegExp.hasMatch(newValue.text)) {
      return _oldTextEditingValue(oldValue);
    } else {
      return newValue;
    }
  });
}

TextEditingValue _oldTextEditingValue(TextEditingValue oldValue) {
  return TextEditingValue(
    text: oldValue.text,
    selection: TextSelection.fromPosition(
      TextPosition(
        offset: oldValue.text.length,
        affinity: TextAffinity.upstream,
      ),
    ),
  );
}
