import 'package:flutter/material.dart';
import 'package:osu_tourney/src/service/api_service.dart';

class BeatmapScores extends StatefulWidget {
  final int beatmapId;
  final String difficultyName;

  const BeatmapScores({super.key, required this.beatmapId, required this.difficultyName});

  static const routeName = '/beatmapScores';

  @override
  _BeatmapScoresState createState() => _BeatmapScoresState();
}

class _BeatmapScoresState extends State<BeatmapScores> {
  late Future<List<Map<String, dynamic>>> _scoresFuture;
  final OsuApiService _apiService = OsuApiService();

  @override
  void initState() {
    super.initState();
    _scoresFuture = _apiService.fetchScoresForBeatmap(widget.beatmapId, [37335151, 32074448, 37213715, 24868771, 29806966, 16342641]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.difficultyName),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No scores available."));
          } else {
            final scores = snapshot.data!;
            scores.sort((a, b) => b['score'].compareTo(a['score']));
            return ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return ListTile(
                  title: Text("Username: ${score['username']}"),
                  subtitle: Text("Score: ${score['score']}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}