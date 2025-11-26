import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  String? _token;

  ApiService(String baseUrl) : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  void setToken(String token) {
    _token = token;
  }

  Options _getOptions(Options? options) {
    if (_token != null) {
      final headers = options?.headers ?? {};
      headers['Authorization'] = 'Bearer $_token';
      return Options(headers: headers);
    }
    return options ?? Options();
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters, options: _getOptions(options));
  }

  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.post(endpoint, data: data, queryParameters: queryParameters, options: _getOptions(options));
  }

  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.put(endpoint, data: data, queryParameters: queryParameters, options: _getOptions(options));
  }

  Future<Response> patch(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.patch(endpoint, data: data, queryParameters: queryParameters, options: _getOptions(options));
  }

  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.delete(endpoint, data: data, queryParameters: queryParameters, options: _getOptions(options));
  }
}