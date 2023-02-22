import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mintness/repositories/local_storage.dart';
enum Rest {
  PUT,
  GET,
  POST,
  DELETE,
}

class DioClient {
  final Dio _dio = Dio();

  Future<Response> callDio(
    Rest rest,
    String path, {
        dynamic   data,
  }) async {
    print('path: $path');
    print('params: ${data}');
    _dio.options.headers["authorization"] =
        'Bearer ${LocalStorage().accessToken}';

    try {
      Response response;
      switch (rest) {
        case Rest.PUT:
          Map<String, dynamic> newMap = {};
          print('data: $data');
          data?.keys?.toList()?.forEach((key) {
            newMap.addAll({
              "${key}" : data[key]
            });
          });
        //  print('newMap $newMap');
          response = await _dio.put( path,

                 queryParameters: newMap,
                 options: Options(contentType: Headers.jsonContentType)
               );


          break;
        case Rest.GET:
          response = await _dio.get(path,
              queryParameters: data ,
              options: Options(contentType: Headers.jsonContentType));
          break;
        case Rest.POST:
          response = await _dio.post(path,
              //data: data,
              queryParameters:  data,
              options: Options(contentType: Headers.jsonContentType)
          );

          break;
        case Rest.DELETE:
          response = await _dio.delete(path, data: data);
          break;
      }
      print('status code: ${response.statusCode}');
      return response;
    } on DioError catch (e) {
      log("message ${e}");
      log("statusMessage ${e.response.statusMessage}");
      log("response message ${e.message}");
      //log("response error ${e.error}");
    //  log("response type ${e.type}");

      if (e.type == DioErrorType.connectTimeout)
        throw _platformException("Timeout error", "TIMEOUT_ERROR");
      if (e.type == DioErrorType.sendTimeout)
        if (e.type ==
          DioErrorType.receiveTimeout) if (e
              .type ==
          DioErrorType.response) if (e
              .type ==
          DioErrorType.cancel) if (e.error is SocketException)
        throw _platformException(
            "Internet connection error", "CONNECTION_ERROR");

      // for Edit Time page, Add Time page
      return e.response;
    }
    return null;
  }

  PlatformException _platformException(String message, String code) {
    return PlatformException(
      message: message,
      code: code,
    );
  }
}
