import 'dart:convert';
import 'package:http/http.dart' as http;

class OsuApiService {
  static const String _baseUrl = "https://osu.ppy.sh/api/v2";
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

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse("https://osu.ppy.sh/oauth/token"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'grant_type': 'client_credentials',
        'scope': 'public',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchScoresForUsers(List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate();
    }

    List<Map<String, dynamic>> allScores = [];

    for (int userId in userIds) {
      final response = await http.get(
        Uri.parse("$_baseUrl/users/$userId/osu"),
        headers: {'Authorization': 'Bearer $_accessToken'},
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


  Future<List<Map<String, dynamic>>> fetchScoresForBeatmap(int beatmapId, List<int> userIds) async {
    if (_accessToken == null) {
      await authenticate();
    }

    List<Map<String, dynamic>> allScores = [];

    for (int userId in userIds) {
      final response = await http.get(
        Uri.parse("$_baseUrl/beatmaps/$beatmapId/scores/users/$userId"),
        headers: {'Authorization': 'Bearer $_accessToken'},
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


  Future<List<Map<String, dynamic>>> fetchBeatmapDifficulties(int beatmapId) async {
    if (_accessToken == null) {
      await authenticate();
    }

    final response = await http.get(
      Uri.parse("$_baseUrl/beatmapsets/$beatmapId"),
      headers: {'Authorization': 'Bearer $_accessToken'},
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