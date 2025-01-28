import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          String title;
          switch (item.id) {
            case 1:
              title = 'Overall Ranking';
              break;
            case 2:
              title = 'Beatmaps';
              break;
            case 3:
              title = 'Placeholder';
              break;
            default:
              title = 'SampleItem ${item.id}';
          }

          Icon leadingIcon;
          switch (item.id) {
            case 1:
              leadingIcon = const Icon(Icons.bar_chart); // Graph icon
              break;
            case 2:
              leadingIcon = const Icon(Icons.arrow_forward); // Arrow icon
              break;
            case 3:
              leadingIcon = const Icon(Icons.close); // X icon
              break;
            default:
              leadingIcon = const Icon(Icons.help); // Default icon
          }

          return ListTile(
            title: Text(title),
            leading: leadingIcon,
            onTap: () {
              if (item.id == 1) {
                Navigator.restorablePushNamed(
                  context,
                  '/rankingsList',
                );
              } else if (item.id == 2) {
                Navigator.restorablePushNamed(
                  context,
                  '/beatmaps',
                );
              } else if (item.id == 3) {
                Navigator.restorablePushNamed(
                  context,
                  '/test',
                );
              }
            }
          );
        },
      ),
    );
  }
}