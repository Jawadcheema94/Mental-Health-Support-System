// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000'; // Backend URL

//   // Signup Function
//   static Future<Map<String, dynamic>> signup(String username, String email, String password, String? role, {required String role}) async {
//     final url = Uri.parse('$baseUrl/signup');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'email': email, 'password': password}),
//       );

//       if (response.statusCode == 201) {
//         return {'success': true, 'message': 'Signup successful'};
//       } else {
//         final data = jsonDecode(response.body);
//         return {'success': false, 'message': data['error'] ?? 'Signup failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Error connecting to server'};
//     }
//   }

//   // Login Function
//   static Future<Map<String, dynamic>> login(String username, String password) async {
//     final url = Uri.parse('$baseUrl/login');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {'success': true, 'token': data['token']};
//       } else {
//         final data = jsonDecode(response.body);
//         return {'success': false, 'message': data['error'] ?? 'Login failed'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Error connecting to server'};
//     }
//   }
// }
