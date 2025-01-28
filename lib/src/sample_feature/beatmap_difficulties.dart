import 'package:flutter/material.dart';
import 'package:osu_tourney/src/sample_feature/beatmap_scores.dart';
import 'package:osu_tourney/src/service/api_service.dart';

class BeatmapDifficulties extends StatefulWidget {
  final int beatmapId;
  final String beatmapTitle;

  const BeatmapDifficulties({super.key, required this.beatmapId, required this.beatmapTitle});

  static const routeName = '/beatmapDifficulties';

  @override
  _BeatmapDifficultiesState createState() => _BeatmapDifficultiesState();
}

class _BeatmapDifficultiesState extends State<BeatmapDifficulties> {
  late Future<List<Map<String, dynamic>>> _difficultiesFuture;
  final OsuApiService _apiService = OsuApiService();

  @override
  void initState() {
    super.initState();
    _difficultiesFuture = _apiService.fetchBeatmapDifficulties(widget.beatmapId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beatmapTitle),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _difficultiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No difficulties available."));
          } else {
            final difficulties = snapshot.data!;
            difficulties.sort((b, a) => b['difficulty_rating'].compareTo(a['difficulty_rating']));
            return ListView.builder(
              itemCount: difficulties.length,
              itemBuilder: (context, index) {
                final difficulty = difficulties[index];
                return ListTile(
                  title: Text("Difficulty: ${difficulty['version']}"),
                  subtitle: Text("Stars: ${difficulty['difficulty_rating']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeatmapScores(
                          beatmapId: difficulty['id'],
                          difficultyName: difficulty['version'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}