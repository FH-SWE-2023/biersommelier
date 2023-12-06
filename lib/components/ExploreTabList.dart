import 'dart:io';

import 'package:flutter/material.dart';

import '../database/entities/Bar.dart';
import '../database/entities/Beer.dart';

import '../imagemanager/ImageManager.dart';

/// Creates the ExploreBar Component which contains the ExploreTabBar and the ExploreList with Locals and Beers
class ExploreBar extends StatefulWidget {
  final bool onlyFavorites;

  const ExploreBar({super.key, this.onlyFavorites = false});

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
              ExploreList(isBar: true, onlyFavorites: widget.onlyFavorites), // For 'Lokale' which represents bars
              ExploreList(isBar: false, onlyFavorites: widget.onlyFavorites), // For 'Biere' which represents beers
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
        unselectedLabelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // width: 16px
                Image.asset('assets/icons/pin.png', width: 30, height: 30),
                const SizedBox(width: 5),
                const Text('Lokale'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // width: 16px
                Image.asset('assets/icons/beer.png', width: 30, height: 30),
                const SizedBox(width: 5),
                const Text('Biere'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ExploreList sub-component
class ExploreList extends StatelessWidget {
  final bool isBar; // To determine whether we are displaying Bars or Beers
  final bool onlyFavorites;

  ExploreList({required this.isBar, required this.onlyFavorites}) : super(key: UniqueKey());

  final ImageManager imageManager = ImageManager(); // Instance of ImageManager

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: isBar
          ? Bar.getAll(onlyFavorites: onlyFavorites)
          : Beer.getAll(onlyFavorites: onlyFavorites),
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
                    ? null
                    : FutureBuilder<Image>(
                  future: imageManager.getImageByKey(item.id),
                  builder: (BuildContext context, AsyncSnapshot<Image> imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.done && imageSnapshot.hasData) {
                      return SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: imageSnapshot.data,
                      );
                    } else if (imageSnapshot.hasError) {
                      return const Icon(Icons.error);
                    } else {
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

