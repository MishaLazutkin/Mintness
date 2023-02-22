import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/files.dart';
import 'package:mintness/models/domain/priorities.dart';


@immutable
class FilesResponse {
  final Files files;

  const FilesResponse.success({@required this.files});
  const FilesResponse.error() : files = null;

  factory FilesResponse.fromResponse( Response response) {
    try {
     log('Files response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return FilesResponse.success(
        files: Files.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Files parsing ERROR: $exception');
      print(stackTrace);
      return const FilesResponse.error();
    }
  }
}