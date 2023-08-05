import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiClient extends DioForNative {
  ApiClient()
      : super(
          BaseOptions(
              responseType: ResponseType.json,
              contentType: Headers.jsonContentType,
              headers: {'Accept': 'application/json'}),
        );
}