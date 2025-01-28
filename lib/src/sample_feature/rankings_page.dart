import 'package:flutter/material.dart';
import 'package:osu_tourney/src/service/api_service.dart';

class RankingsList extends StatefulWidget {
  const RankingsList({super.key});

  @override
  _RankingsListState createState() => _RankingsListState();
}

class _RankingsListState extends State<RankingsList> {
  late Future<List<Map<String, dynamic>>> _rankingsFuture;
  final OsuApiService _apiService = OsuApiService();

  @override
  void initState() {
    super.initState();
    _rankingsFuture = _apiService.fetchScoresForUsers([37335151, 32074448, 37213715, 24868771, 29806966, 16342641]).then((value) => value.cast<Map<String, dynamic>>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("osu! Rankings"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _rankingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No rankings available."));
          } else {
            final rankings = snapshot.data!;
            rankings.sort((a, b) => b['pp'].compareTo(a['pp']));
            return ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final user = rankings[index];
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text("Username: ${user['username']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PP: ${user['pp']}"),
                      Text("Global Rank: ${user['global_rank']}"),
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