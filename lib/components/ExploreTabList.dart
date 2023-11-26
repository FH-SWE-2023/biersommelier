import 'package:flutter/material.dart';

import '../database/entities/Bar.dart';
import '../database/entities/Beer.dart';

// ExploreBar component
class ExploreBar extends StatefulWidget {
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

  const ExploreTabBar({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: isBar ? Bar.getAll() : Beer.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final items = snapshot.data!;

          return ListView.builder(
            key: PageStorageKey(isBar ? 'BarsList' : 'BeersList'), // Unique key for PageStorage
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: isBar ? Icon(Icons.store) : Icon(Icons.local_drink),
                title: Text(item.name),
                subtitle: Text(isBar ? item.location.toString() : item.imageId),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
