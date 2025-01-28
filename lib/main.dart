import 'package:flutter/material.dart';
import 'package:osu_tourney/src/sample_feature/test_page.dart';
import 'src/sample_feature/beatmaps_page.dart';
import 'src/sample_feature/item_list_view.dart';
import 'src/sample_feature/rankings_page.dart';
import 'src/sample_feature/beatmaps/ado.dart';
import 'src/sample_feature/beatmap_difficulties.dart';
import 'src/sample_feature/beatmap_scores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'osu! Tourney',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SampleItemListView.routeName: (context) => const SampleItemListView(),
        '/rankingsList': (context) => const RankingsList(),
        Beatmaps.routeName: (context) => const Beatmaps(),
        Ado.routeName: (context) => const Ado(),
        TestPage.routeName: (context) => const TestPage(),
      },
      initialRoute: SampleItemListView.routeName, // Set the initial route
      onGenerateRoute: (settings) {
        if (settings.name == BeatmapDifficulties.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return BeatmapDifficulties(
                beatmapId: args['beatmapId'],
                beatmapTitle: args['beatmapTitle'],
              );
            },
          );
        } else if (settings.name == BeatmapScores.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return BeatmapScores(
                beatmapId: args['beatmapId'],
                difficultyName: args['difficultyName'],
              );
            },
          );
        }
        return null;
      },
    );
  }
}