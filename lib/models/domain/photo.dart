import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
class Photo {

  final List<int> bytes;
  final String extension;
  final String name;
  final String identifier;

  const Photo({this.bytes, this.extension, this.name, this.identifier});

  String get formattedExtension {
  	final lowerExtension = extension.toLowerCase();
	return lowerExtension != 'jpg' ? lowerExtension : 'jpeg';
  }

  String toBase64() =>
      'data:image/$formattedExtension;base64,${base64Encode(bytes)}';
}
