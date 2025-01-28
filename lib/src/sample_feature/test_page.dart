import 'package:flutter/material.dart';
import 'package:osu_tourney/src/service/api_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  static const routeName = '/test';

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<List<Map<String, dynamic>>> _difficultiesFuture;
  final OsuApiService _apiService = OsuApiService();

  @override
  void initState() {
    super.initState();
    _difficultiesFuture = _apiService.fetchBeatmapDifficulties(1450065); // Example beatmap ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
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
            return ListView.builder(
              itemCount: difficulties.length,
              itemBuilder: (context, index) {
                final difficulty = difficulties[index];
                return ListTile(
                  title: Text("Difficulty: ${difficulty['version']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stars: ${difficulty['difficulty_rating']}"),
                      Text("Max Combo: ${difficulty['max_combo']}"),
                      Text("Approach Rate: ${difficulty['ar']}"),
                      Text("Overall Difficulty: ${difficulty['od']}"),
                      Text("HP Drain Rate: ${difficulty['drain']}"),
                      Text("Circle Size: ${difficulty['cs']}"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}