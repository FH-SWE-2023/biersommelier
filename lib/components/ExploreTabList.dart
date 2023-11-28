import 'dart:io';

import 'package:flutter/material.dart';

import '../database/entities/Bar.dart';
import '../database/entities/Beer.dart';

import '../imagemanager/ImageManager.dart';

// ExploreBar component
class ExploreBar extends StatefulWidget {
  const ExploreBar({super.key});

  @override
  _ExploreBarState createState() => _ExploreBarState();
}

class _ExploreBarState extends State<ExploreBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExploreTabBar(tabController: _tabController),
        Flexible(
          // Wrapping TabBarView with Flexible
          child: TabBarView(
            controller: _tabController,
            children: [
              ExploreList(isBar: true), // For 'Lokale' which represents bars
              ExploreList(isBar: false), // For 'Biere' which represents beers
            ],
          ),
        ),
      ],
    );
  }
}

// ExploreTabBar sub-component
class ExploreTabBar extends StatelessWidget {
  final TabController tabController;

  const ExploreTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Lokale'),
          Tab(text: 'Biere'),
        ],
      ),
    );
  }
}

// ExploreList sub-component
class ExploreList extends StatelessWidget {
  final bool isBar; // To determine whether we are displaying Bars or Beers

  ExploreList({required this.isBar}) : super(key: UniqueKey());

  final ImageManager imageManager = ImageManager(); // Instance of ImageManager

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: isBar ? Bar.getAll() : Beer.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final items = snapshot.data!;

          return ListView.builder(
            key: PageStorageKey(isBar ? 'BarsList' : 'BeersList'),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                leading: isBar
                    ? const SizedBox.shrink()
                    : FutureBuilder<File>(
                  future: imageManager.getImageByKey(item.id), // Using the instance here
                  builder: (BuildContext context, AsyncSnapshot<File> imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.done && imageSnapshot.data != null) {
                      // Constrain the image to a square
                      return SizedBox(
                        width: 50.0, // Specify your desired square size
                        height: 50.0,
                        child: Image(
                          image: FileImage(imageSnapshot.data!),
                          fit: BoxFit.cover, // This ensures the image covers the square
                        ),
                      );
                    } else if (imageSnapshot.error != null) {
                      return const Icon(Icons.local_drink);
                    } else {
                      // Show a square box as a placeholder
                      return const SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                title: Text(item.name),
                subtitle: isBar ? Text(item.address) : const SizedBox.shrink(),
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // TODO: Add PopupMenu
                  },
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

