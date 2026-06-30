import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {

  static const String baseUrl = "http://192.168.1.12:5000";

  Future<Map<String, dynamic>> register({
    required String token,
    required String name,
    required String role,
    String? village,
    String? taluk,
    String? district,
    String? pincode,
  }) async {
    print("========== REGISTER ==========");
    print("URL: $baseUrl/api/register");
    print("TOKEN: ${token.substring(0, 20)}...");

    final response = await http.post(
      Uri.parse("$baseUrl/api/register"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "role": role,
        "village": village,
        "taluk": taluk,
        "district": district,
        "pincode": pincode,
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    return jsonDecode(response.body);
  }


  Future<Map<String, dynamic>> login(String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/login"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

}