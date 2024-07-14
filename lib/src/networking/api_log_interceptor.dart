import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
// import 'package:logger/logger.dart';



class EnhancedLogInterceptor extends Interceptor {
  static const String _reset = '\x1B[0m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _purple = '\x1B[35m';

  void _logWithColor(String message, {required String color}) {
    debugPrint('$color$message$_reset');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logWithColor('┌─────── 🚀 Calling API ───────>', color: _purple);
    _logWithColor('│ 📡 ${options.method} : ${options.uri}', color: _yellow);
    _logWithColor('│ 📦 Calling Parameters:', color: _blue);

    if (options.method == 'GET') {
      if (options.queryParameters.isNotEmpty) {
        _logWithColor('│ 🔍 Query Parameters:', color: _blue);
        options.queryParameters.forEach((key, value) {
          _logWithColor('│   🔑 $key: $value', color: _cyan);
        });
      } else {
        _logWithColor('│   🚫 No query parameters', color: _cyan);
      }
    } else if (options.data != null) {
      _logWithColor('│ 📄 Body: ${options.data}', color: _cyan);
    }

    _logWithColor('│ 🔖 Headers:', color: _blue);
    options.headers.forEach((key, value) {
      _logWithColor('│ 🏷️ $key: $value', color: _cyan);
    });

    _logWithColor('└─────── 🏁 End Calling API ───────>', color: _blue);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logWithColor('┌─────── ✅ API Response ───────>', color: _green);
    _logWithColor('│ 📡 ${response.requestOptions.method} ${response.requestOptions.uri}', color: _yellow);
    _logWithColor('│ 🔢 Status Code: ${response.statusCode}', color: _blue);
    _logWithColor('│ 📊 Status Message: ${response.statusMessage}', color: _red);
    _logWithColor('│ 📦 Response Data:', color: _cyan);
    _logWithColor('│ 📄 ${response.data}', color: _green);
    _logWithColor('└─────── 🏁 End API Response ───────>', color: _green);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logWithColor('┌─────── ❌ API Error ───────>', color: _red);
    _logWithColor('│ 📡 ${err.requestOptions.method} ${err.requestOptions.uri}', color: _red);
    _logWithColor('│ 🔍 Error Type: ${err.type}', color: _red);
    _logWithColor('│ 💬 Error Message: ${err.message}', color: _red);
    if (err.response != null) {
      _logWithColor('│ 🔢 Status Code: ${err.response?.statusCode}', color: _blue);
      _logWithColor('│ 📊 Status Message: ${err.response?.statusMessage}', color: _blue);
      _logWithColor('│ 📄 Error Data: ${err.response?.data}', color: _cyan);
    }
    _logWithColor('└─────── 🏁 End API Error ───────>', color: _red);
    super.onError(err, handler);
  }
}

//with logger
// class ColoredLogInterceptor extends Interceptor {
//   final Logger _logger = Logger(
//     printer: PrettyPrinter(
//       methodCount: 0,
//       errorMethodCount: 5,
//       lineLength: 120,
//       colors: true,
//       printEmojis: true,
//       printTime: true,
//     ),
//   );

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
//     _logger.d('Headers:');
//     options.headers.forEach((key, value) {
//       _logger.d('$key: $value');
//     });
//     if (options.data != null) {
//       _logger.d('Body: ${options.data}');
//     }
//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     _logger.i(
//       'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
//     );
//     _logger.d('Response Data:');
//     _logger.d(response.data);
//     super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     _logger.e(
//       'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
//     );
//     _logger.e('Error Type: ${err.type}');
//     _logger.e('Error Message: ${err.message}');
//     if (err.response != null) {
//       _logger.e('Error Data: ${err.response?.data}');
//     }
//     super.onError(err, handler);
//   }
// }

