import 'dart:convert';
import 'package:http/http.dart' as http;

class OsuApiService {
  // Update the base URL to your Render backend
  static const String _baseUrl = "https://osu-backend.onrender.com";
  String? _accessToken;

  final Map<int, String> userIdToUsername = {
    37335151: 'sportsocke',
    32074448: 'tammmm',
    37213715: 'Sidir0z',
    24868771: 'Strwberry',
    29806966: 'AE_Archon',
    16342641: 'Kxrlmon',
  };

  // Authenticate by calling the backend's /osu/auth endpoint
  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse("$_baseUrl/osu/auth"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }

  // Fetch scores for users by calling the backend
  Future<List<dynamic>> fetchScoresForUsers(List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final response = await http.post(
      Uri.parse("$_baseUrl/users/scores"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({'user_ids': userIds}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch scores for users: ${response.body}");
    }
  }

  // Fetch beatmap scores using the backend
  Future<List<Map<String, dynamic>>> fetchScoresForBeatmap(int beatmapId, List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final response = await http.post(
      Uri.parse("$_baseUrl/beatmaps/$beatmapId/scores"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({'user_ids': userIds}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch beatmap scores: ${response.body}");
    }
  }

  // Fetch beatmap difficulties using the backend
  Future<List<Map<String, dynamic>>> fetchBeatmapDifficulties(int beatmapId) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final response = await http.get(
      Uri.parse("$_baseUrl/beatmaps/$beatmapId/difficulties"),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch beatmap difficulties: ${response.body}");
    }
  }
}
