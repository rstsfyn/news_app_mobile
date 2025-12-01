import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
    ));
  }

  Future<Response> login(String email, String password) async {
    return await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Response> logout() async {
    return await _dio.post('/logout');
  }

  Future<Response> getUser() async {
    return await _dio.get('/user');
  }

  // News endpoints
  Future<Response> getNews() async {
    return await _dio.get('/news');
  }

  Future<Response> getNewsDetail(int id) async {
    return await _dio.get('/news/$id');
  }

  Future<Response> createNews(Map<String, dynamic> data) async {
    return await _dio.post('/news', data: data);
  }

  // Comment endpoints
  Future<Response> addComment(int newsId, String content) async {
    return await _dio.post('/news/$newsId/comments', data: {
      'content': content,
    });
  }
}
