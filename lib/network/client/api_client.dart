import 'package:covid19status/network/rest_constants.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _converter = ApiClient._internal();

  factory ApiClient() {
    return _converter;
  }

  ApiClient._internal();

  Dio dio() {
    var dio = Dio(
      BaseOptions(
          connectTimeout: 5000,
          contentType: 'content-type: application/json; charset=utf-8',
          receiveTimeout: 3000,
          baseUrl: RestConstants.BASE_URL),
    );

    dio.interceptors.addAll(
      [
        LogInterceptor(
          error: true,
          requestBody: true,
        ),
      ],
    );
    return dio;
  }
}
