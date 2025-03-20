import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class LoginRemoteDataSource {
  Future<String> login(String username, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  @override
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://your-api-url/auth/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      final token = json.decode(response.body)['access_token'];
      return token;
    } else {
      throw Exception('Login failed');
    }
  }
}
