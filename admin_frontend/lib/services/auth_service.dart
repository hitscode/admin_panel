import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // final String _baseUrl =
  //     "http://192.168.81.214:8000"; // Update with your FastAPI URL
  final String _baseUrl = "https://admin-panel-hmwu.onrender.com";

  // Login Function
  Future<bool> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        '$_baseUrl/token',
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        await _storage.write(
          key: "token",
          value: response.data["access_token"],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // Logout Function
  Future<void> logout() async {
    await _storage.delete(key: "token");
  }

  // Get Token
  Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }
}
