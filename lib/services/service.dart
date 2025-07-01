import 'dart:convert';
import 'package:http/http.dart' as http;

class JournalService {
  static const String baseUrl =
      "http://localhost:3000/api/journal"; // Replace with actual backend URL

  // Fetch journal entries from API
  static Future<List<Map<String, String>>> fetchJournalEntries(
      String userId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/journal?userId=$userId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((entry) => {
                "date": entry["entryDate"].toString(),
                "entry": entry["content"].toString(),
              })
          .toList();
    } else {
      throw Exception("Failed to load journal entries");
    }
  }

  // Create a new journal entry
  static Future<void> createJournalEntry({
    required String userId,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "entry": content,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create journal entry");
    }
  }
}
