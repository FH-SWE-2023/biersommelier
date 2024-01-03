import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/components/misc/ConditionalConsumer.dart';
import 'package:biersommelier/providers/BarChanged.dart';
import 'package:biersommelier/providers/BeerChanged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/database/entities/Beer.dart';

import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:biersommelier/components/ConfirmationDialog.dart';
import 'package:biersommelier/router/Rut.dart';

import '../pages/AddBar.dart';
import '../pages/AddBeer.dart';

/// Creates the ExploreBar Component which contains the ExploreTabBar and the ExploreList with Locals and Beers
class ExploreBar extends StatefulWidget {
  final bool onlyFavorites;
  final Function(Bar)? onBarAddressClick;

  const ExploreBar(
      {super.key, this.onlyFavorites = false, this.onBarAddressClick});

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
              ExploreList(
                  isBar: true,
                  onlyFavorites: widget.onlyFavorites,
                  onChanged: Provider.of<BarChanged>(context, listen: false)
                      .notify, // For 'Lokale' which represents bars
                  onBarAddressClick: widget.onBarAddressClick),
              ExploreList(
                  isBar: false,
                  onlyFavorites: widget.onlyFavorites,
                  onChanged: Provider.of<BeerChanged>(context, listen: false)
                      .notify), // For 'Biere' which represents beers
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
  final Function onChanged;
  final Function(Bar)? onBarAddressClick;

  ExploreList(
      {super.key,
      required this.isBar,
      required this.onlyFavorites,
      required this.onChanged,
      this.onBarAddressClick});

  @override
  Widget build(BuildContext context) {
    return ConditionalConsumer(
        type: isBar ? ConsumerType.bar : ConsumerType.beer,
        builder: (context) {
          return FutureBuilder<List<dynamic>>(
            future: isBar
                ? Bar.getAll(onlyFavorites: onlyFavorites)
                : Beer.getAll(onlyFavorites: onlyFavorites),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                              future: ImageManager.getImageByKey(item.imageId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Image> imageSnapshot) {
                                if (imageSnapshot.connectionState ==
                                        ConnectionState.done &&
                                    imageSnapshot.hasData) {
                                  return SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: imageSnapshot.data,
                                    ),
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
                      title: isBar
                          ? Text(item.name)
                          : Container(
                              transform: Matrix4.translationValues(0, 8, 0),
                              child: Text(item.name)),
                      subtitle: isBar
                          ? (onBarAddressClick == null
                              ? Text(item.address)
                              : GestureDetector(
                                  onTap: () => {onBarAddressClick!(item)},
                                  child: Text(item.address)))
                          : const SizedBox.shrink(),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          if (onlyFavorites) {
                            Rut.of(context).showDialog(Popup.deleteFavorite(
                              pressDelete: () {
                                // show confirmation dialog
                                Rut.of(context).showDialog(ConfirmationDialog(
                                  description:
                                      'Bist du sicher, dass du\ndiesen Favoriten löschen\nmöchtest?',
                                  onConfirm: () {
                                    if (isBar) {
                                      Bar.toggleFavorite(item.id).then(
                                          (_) => onChanged()); // Update here
                                    } else {
                                      Beer.toggleFavorite(item.id).then(
                                          (_) => onChanged()); // Update here
                                    }
                                    // show toast
                                    context.showToast(
                                      Toast.levelToast(
                                        message: "Favorit gelöscht!",
                                        level: ToastLevel.success,
                                      ),
                                    );
                                  Rut.of(context).showDialog(null);
                                },
                                onCancel: () {
                                  Rut.of(context).showDialog(null);
                                },
                              ));
                            },
                            onAbort: () {
                              Rut.of(context).showDialog(null);
                            },
                          ));
                        } else {
                          Rut.of(context).showDialog(Popup.editExplore(
                            pressEdit: () {
                              Rut.of(context).showDialog(null);
                              OverlayEntry? addOverlay;
                              if (isBar) {
                                addOverlay = createAddBarOverlay(context, () => Rut.of(context).showOverlay(null), item);
                                Rut.of(context).showOverlayEntry(addOverlay);
                              } else {
                                if (item.imageId != null && item.imageId?.isNotEmpty) {
                                  ImageManager.getImageFileByKey(item.imageId).then((value) {
                                    addOverlay = createAddBeerOverlay(context, () => Rut.of(context).showOverlay(null), item, value);
                                    Rut.of(context).showOverlayEntry(addOverlay!);
                                  });
                                } else {
                                  addOverlay = createAddBeerOverlay(context, () => Rut.of(context).showOverlay(null), item, null);
                                  Rut.of(context).showOverlayEntry(addOverlay);
                                }
                              }
                            },
                            pressFavorite: () {
                              if (isBar) {
                                Bar.toggleFavorite(item.id).then((_) => onChanged()); // Update here
                              } else {
                                Beer.toggleFavorite(item.id).then((_) => onChanged()); // Update here
                              }
                              Rut.of(context).showDialog(null);
                            },
                            pressDelete: () {
                              // show confirmation dialog
                              Rut.of(context).showDialog(ConfirmationDialog(
                                description: 'Bist du sicher, dass du dieses ${isBar ? 'Lokal' : 'Bier'} löschen möchtest?\nAlle Beiträge zu diesem ${isBar ? 'Lokal' : 'Bier'} werden ebenfalls gelöscht!',
                                onConfirm: () {
                                  if (isBar) {
                                    Bar.delete(item.id).then((_) => onChanged()); // Update here
                                  } else {
                                    Beer.delete(item.id).then((_) => onChanged()); // Update here
                                  }
                                  // show toast
                                  context.showToast(
                                    Toast.levelToast(
                                      message: "${isBar ? 'Lokal' : 'Bier'} gelöscht!",
                                      level: ToastLevel.success,
                                    ),
                                  );

                                  Rut.of(context).showDialog(null);
                                },
                                onCancel: () {
                                  Rut.of(context).showDialog(null);
                                },
                                ));
                              },
                              onAbort: () {
                                Rut.of(context).showDialog(null);
                              },
                              title: isBar ? "Lokal" : "Bier",
                              favorite: item.isFavorite,
                            ));
                          }
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
        });
  }
}
