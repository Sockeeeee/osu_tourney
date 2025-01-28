import 'dart:convert';
import 'package:http/http.dart' as http;

class OsuApiService {
  static const String _baseUrl = "https://osu-proxy.onrender.com"; // Updated to use Render proxy
  final String _clientId = "37763";
  final String _clientSecret = "UwAh0Dk0LmjJTywxsFYvf5YT04gtOqf0nCUEzg6l";
  String? _accessToken;

  final Map<int, String> userIdToUsername = {
    37335151: 'sportsocke',
    32074448: 'tammmm',
    37213715: 'Sidir0z',
    24868771: 'Strwberry',
    29806966: 'AE_Archon',
    16342641: 'Kxrlmon',
  };

  // Function to authenticate via Render proxy
  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse("$_baseUrl/osu/auth"), // Use Render proxy for authentication
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token']; // Save the access token
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }

  // Function to fetch scores for users
  Future<List<dynamic>> fetchScoresForUsers(List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate(); // Authenticate if there's no token
    }

    List<Map<String, dynamic>> allScores = [];

    for (int userId in userIds) {
      final response = await http.get(
        Uri.parse("$_baseUrl/users/$userId/osu"),
        headers: {'Authorization': 'Bearer $_accessToken'}, // Send the access token
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userStats = data['statistics'];
        if (userStats != null) {
          allScores.add({
            'user_id': userId,
            'username': data['username'],
            'pp': userStats['pp'],
            'global_rank': userStats['global_rank'],
          });
        }
      } else {
        throw Exception("Failed to fetch scores for user $userId: ${response.body}");
      }
    }

    return allScores;
  }

  // Function to fetch scores for a beatmap
  Future<List<Map<String, dynamic>>> fetchScoresForBeatmap(int beatmapId, List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate(); // Authenticate if there's no token
    }

    List<Map<String, dynamic>> allScores = [];

    for (int userId in userIds) {
      final response = await http.get(
        Uri.parse("$_baseUrl/beatmaps/$beatmapId/scores/users/$userId"),
        headers: {'Authorization': 'Bearer $_accessToken'}, // Send the access token
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('score')) {
          final scoreData = data['score'];
          allScores.add({
            'username': userIdToUsername[userId] ?? 'Unknown',
            'user_id': userId,
            'score': scoreData['score'],
          });
        } else {
          // User has not played the map, add a default score of 0
          allScores.add({
            'username': userIdToUsername[userId] ?? 'Unknown',
            'user_id': userId,
            'score': 0,
          });
        }
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData['error'] == null) {
          // User has not played the map, add a default score of 0
          allScores.add({
            'username': userIdToUsername[userId] ?? 'Unknown',
            'user_id': userId,
            'score': 0,
          });
        } else {
          throw Exception("Failed to fetch scores for user $userId: ${response.body}");
        }
      }
    }

    return allScores;
  }

  // Function to fetch beatmap difficulties
  Future<List<Map<String, dynamic>>> fetchBeatmapDifficulties(int beatmapId) async {
    if (_accessToken == null) {
      await authenticate(); // Authenticate if there's no token
    }

    final response = await http.get(
      Uri.parse("$_baseUrl/beatmapsets/$beatmapId"),
      headers: {'Authorization': 'Bearer $_accessToken'}, // Send the access token
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('beatmaps')) {
        final beatmaps = data['beatmaps'] as List;
        return beatmaps.map((beatmap) => beatmap as Map<String, dynamic>).toList();
      } else {
        throw Exception("Unexpected response format: ${response.body}");
      }
    } else {
      throw Exception("Failed to fetch beatmap difficulties: ${response.body}");
    }
  }
}
