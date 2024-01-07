import 'package:biersommelier/components/ExploreTabList.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/MapWidget.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:biersommelier/pages/AddBeer.dart';
import 'package:biersommelier/pages/AddBar.dart';
import 'package:flutter/material.dart';

import 'package:biersommelier/providers/BarChanged.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final ValueNotifier<bool> _tabListExpanded = ValueNotifier<bool>(false);
  final GlobalKey<MapWidgetState> mapKey = GlobalKey<MapWidgetState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Header(
                  title: "Entdecken",
                  backgroundColor: Colors.white,
                  icon: HeaderIcon.add,
                  onAdd: () => showMenu(
                        constraints: const BoxConstraints(maxWidth: 205),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the radius as needed
                        ),
                        context: context,
                        position: const RelativeRect.fromLTRB(10, 80, 0, 0),

                        // Menu to get to the addBar and addBeer Page
                        items: <PopupMenuEntry>[
                          PopupMenuItem(
                            value: 'addBar',
                            onTap: () {
                              OverlayEntry? addBarOverlay;
                              addBarOverlay = createAddBarOverlay(context, () {
                                Rut.of(context).showOverlay(null);
                              }, null);
                              Rut.of(context).showOverlayEntry(addBarOverlay);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 40,
                                    child: Image.asset(
                                        'assets/icons/addBar.png',
                                        scale: 2.1)),
                                const Text('Lokal hinzufügen'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'addBeer',
                            onTap: () {
                              OverlayEntry? addBeerOverlay;
                              addBeerOverlay = createAddBeerOverlay(
                                  context,
                                  () => Rut.of(context).showOverlay(null),
                                  null,
                                  null);
                              Rut.of(context).showOverlayEntry(addBeerOverlay);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 40,
                                    child: Image.asset(
                                        'assets/icons/addBeer.png',
                                        scale: 3.7)),
                                const Text('Bier hinzufügen'),
                              ],
                            ),
                          ),
                        ],
                        elevation: 8.0,
                      )),
              Expanded(child:
                  Consumer<BarChanged>(builder: (context, barChanged, child) {
                return FutureBuilder<List<Bar>>(
                    future: Bar.getAll(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Bar>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final bars = snapshot.data!;
                        return MapWidget(
                          key: mapKey,
                          bars: bars,
                        );
                      } else {
                        return const MapWidget(
                          bars: [],
                        );
                      }
                    });
              })),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
            valueListenable: _tabListExpanded,
            builder: (BuildContext context, bool value, Widget? child) =>
                Positioned(
                  bottom: 0,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(milliseconds: 500),
                    height: _tabListExpanded.value
                        ? MediaQuery.of(context).size.height * 0.7
                        : 50,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: ExploreBar(onBarAddressClick: (bar) {
                            _tabListExpanded.value = false;
                            mapKey.currentState?.setSelectedBar(bar);
                            mapKey.currentState?.mapController.move(
                                bar.location,
                                mapKey.currentState!.mapController.camera.zoom);
                          }),
                        ),
                        Builder(builder: (context) {
                          if (!_tabListExpanded.value) {
                            return Listener(
                              behavior: HitTestBehavior.translucent,
                              onPointerUp: (_) {
                                print("tap down 1");
                                _tabListExpanded.value = true;
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Positioned.fill(
                          top: -20,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: RawMaterialButton(
                                onPressed: () {
                                  _tabListExpanded.value =
                                      !_tabListExpanded.value;
                                },
                                elevation: 1,
                                fillColor: Theme.of(context).colorScheme.white,
                                padding: const EdgeInsets.all(3.0),
                                shape: const CircleBorder(),
                                child: Icon(
                                  _tabListExpanded.value
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 40.0,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
      ],
    );
  }
}
