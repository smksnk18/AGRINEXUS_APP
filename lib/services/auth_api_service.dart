import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthApiService {
  // Change this to your computer's current LAN IP when testing on a physical
  // device, or use 10.0.2.2 for the Android emulator.
  // For production, replace with your deployed backend URL.
  static const String baseUrl =
      "https://agrinexus-backend-1.onrender.com";

  /// Register a new user. Called after OTP verification.
  /// Now includes password so the user can log in later without OTP.
  Future<Map<String, dynamic>> register({
    required String token,
    required String name,
    required String role,
    required String password,
    String? village,
    String? taluk,
    String? district,
    String? pincode,
  }) async {
    print("========== REGISTER ==========");
    print("URL: $baseUrl/api/register");

    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/api/register"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "role": role,
          "password": password,
          "village": village,
          "taluk": taluk,
          "district": district,
          "pincode": pincode,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return _safeDecode(response);
    } on SocketException catch (e) {
      print("REGISTER NETWORK ERROR: $e");
      return {
        "success": false,
        "message": "Could not reach the server. Check your connection."
      };
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }

  /// Login with phone number + password (no OTP needed).
  Future<Map<String, dynamic>> loginWithPassword({
    required String phone,
    required String password,
  }) async {
    print("========== LOGIN ==========");
    print("URL: $baseUrl/api/login");
    print("Phone: $phone");

    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/api/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "password": password,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return _safeDecode(response);
    } on SocketException catch (e) {
      print("LOGIN NETWORK ERROR: $e");
      return {
        "success": false,
        "message": "Could not reach the server. Check your connection."
      };
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }

  Map<String, dynamic> _safeDecode(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {"success": false, "message": "Unexpected response format."};
    } catch (_) {
      return {
        "success": false,
        "message": "Server returned an invalid response (${response.statusCode})."
      };
    }
  }
}