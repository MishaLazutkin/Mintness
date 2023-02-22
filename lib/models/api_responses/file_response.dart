import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/file.dart';


@immutable
class FileResponse {
  final PurpleFile file;

  const FileResponse.success({@required this.file});
  const FileResponse.error() : file = null;

  factory FileResponse.fromResponse( Response response) {
    try {
      log('PurpleFile response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return FileResponse.success(
        file: PurpleFile.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('PurpleFile parsing ERROR: $exception');
      print(stackTrace);
      return const FileResponse.error();
    }
  }
}