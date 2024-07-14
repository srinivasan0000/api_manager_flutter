import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final String message;

  DioExceptions(this.message);

  factory DioExceptions.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return DioExceptions("Request to API server was cancelled");
      case DioExceptionType.connectionTimeout:
        return DioExceptions("Connection timeout with API server");
      case DioExceptionType.receiveTimeout:
        return DioExceptions("Receive timeout in connection with API server");
      case DioExceptionType.badResponse:
        return DioExceptions.fromResponse(error.response?.statusCode, error.response?.data);
      case DioExceptionType.sendTimeout:
        return DioExceptions("Send timeout in connection with API server");
      default:
        return DioExceptions("Something went wrong");
    }
  }

  factory DioExceptions.fromResponse(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return DioExceptions("Bad request");
      case 401:
        return DioExceptions("Unauthorized");
      case 403:
        return DioExceptions("Forbidden");
      case 404:
        return DioExceptions("Not found");
      case 500:
        return DioExceptions("Internal server error");
      default:
        return DioExceptions("Oops something went wrong");
    }
  }

  @override
  String toString() => message;
}
