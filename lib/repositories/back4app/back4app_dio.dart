import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Black4AppDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      options.headers["X-Parse-Application-Id"] =
          dotenv.get("BACK4APP_PARSE_APPLICATION_ID");
      options.headers["X-Parse-REST-API-Key"] =
          dotenv.get("BACK4APP_PARSE_REST_API_KEY");
      debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
      super.onRequest(options, handler);
    } catch (e) {
      debugPrint('REQUEST ERRROR');
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
