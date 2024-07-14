import 'api_constant.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'api_log_interceptor.dart';
import 'api_network_exception.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  late final Dio _dio;

  factory ApiManager() => _instance;

  ApiManager._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: RequestConstants.connectionTimeout),
      receiveTimeout: const Duration(seconds: RequestConstants.receiveTimeout),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: RequestConstants.headers,
      followRedirects: true,
      maxRedirects: 5,
    ));
    _dio.interceptors.add(EnhancedLogInterceptor());
  }

  Future<dynamic> _executeRequest(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _executeRequest(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    return _executeRequest(() => _dio.post(path, data: data));
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    return _executeRequest(() => _dio.put(path, data: data));
  }

  Future<dynamic> delete(String path) async {
    return _executeRequest(() => _dio.delete(path));
  }

  Future<String> downloadFile(String url, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$filename';

      await _dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      return filePath;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}




