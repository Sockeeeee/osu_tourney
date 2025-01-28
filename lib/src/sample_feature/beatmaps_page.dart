import 'package:flutter/material.dart';
import 'package:osu_tourney/src/sample_feature/beatmap_difficulties.dart';

import 'sample_item.dart';

class Beatmaps extends StatelessWidget {
  const Beatmaps({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3), SampleItem(4), SampleItem(5), SampleItem(6), SampleItem(7), SampleItem(8), SampleItem(9), SampleItem(10), SampleItem(11), SampleItem(12), SampleItem(13), SampleItem(14), SampleItem(15), SampleItem(16), SampleItem(17), SampleItem(18), SampleItem(19), SampleItem(20)],
  });

  static const routeName = '/beatmaps';

  final List<SampleItem> items;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beatmaps'),
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          String title;
          int beatmapId;
            switch (item.id) {
              case 1:
                title = 'Ado - Oda';
                beatmapId = 1450065;
                break;
              case 2:
                title = 'Anamanaguchi - Miku';
                beatmapId = 1839623;
                break;
              case 3:
                title = 'Bad Apple!!! - Nomico';
                beatmapId = 10435;
                break;
              case 4:
                title = 'Brain Power - Noma';
                beatmapId = 357777;
                break;
              case 5:
                title = 'Classic Pursuit - cYsmix';
                beatmapId = 488238;
                break;
              case 6:
                title = 'Come Play  Stray Kids';
                beatmapId = 2266003;
                break;
              case 7:
                title = 'Crossing Fields - LISA';
                beatmapId = 68500;
                break;
              case 8:
                title = 'Die For You - Grabbitz';
                beatmapId = 1793500;
                break;
              case 9:
                title = 'Everything Will Freeze - UNDEAD CORP.';
                beatmapId = 158023;
                break;
              case 10:
                title = 'furioso melodia (2017 VIP) -gmtn';
                beatmapId = 1009732;
                break;
              case 11:
                title = 'Idol - YOASOBI';
                beatmapId = 1973430;
                break;
              case 12:
                title = 'Inferno - Mrs. Green Apple';
                beatmapId = 999645;
                break;
              case 13:
                title = 'Kaibutsa - YOASOBI';
                beatmapId = 1328989;
                break;
              case 14:
                title = 'Magnetic - ILLIT';
                beatmapId = 2156751;
                break;
              case 15:
                title = 'My Love - Raphlesia & BilliumMoto';
                beatmapId = 1388906;
                break;
              case 16:
                title = 'No Title - Reol';
                beatmapId = 343672;
                break;
              case 17:
                title = 'Peery Gynt - cYsmix';
                beatmapId = 880487;
                break;
              case 18:
                title = 'Spider thread Monopoly - Miku';
                beatmapId = 348381;
                break;
              case 19:
                title = 'Ticking Away - Grabbitz & BBNOMONEY';
                beatmapId = 2037388;
                break;
              case 20:
                title = 'Yoru ni Kakeru - Yoasobi';
                beatmapId = 1218852;
                break;
              default:
                title = 'SampleItem ${item.id}';
                beatmapId = 1;
            }

              return ListTile(
              title: Text(title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeatmapDifficulties(
                      beatmapId: beatmapId,
                      beatmapTitle: title,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
}