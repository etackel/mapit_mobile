// network_service.dart
import 'package:dio/dio.dart';

class NetworkService {
  late Dio dio;

  NetworkService() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://your-api-url.com',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  void updateDioHeader(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}