import 'dart:io';

import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';

/// A widget that displays a map with markers
/// The map is based on OpenStreetMap
/// The markers are given as a list of [LatLng]s
/// The map is cached for offline use
class MapWidget extends StatefulWidget {
  /// A map of [LatLng]s to functions that are called when the marker is tapped
  final List<Bar> bars;
  /// The initial center of the map
  final LatLng initialCenter;
  /// A function that is called when the map is tapped
  final Function(LatLng)? onTap;
  /// A function that is called when a marker is tapped
  final Function(Bar)? onMarkerTap;

  const MapWidget({super.key, required this.bars, this.initialCenter = const LatLng(50.775555, 6.083611), this.onTap, this.onMarkerTap});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Bar? selectedBar;

  // Create the cache store as a field variable
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  /// Get the CacheStore as a Future
  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();
    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  final tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CacheStore>(
      future: _cacheStoreFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheStore = snapshot.data!;
          return Stack(
            children: [
              FlutterMap( 
                options: MapOptions(
                    initialCenter: widget.initialCenter,
                    initialZoom: 13,
                    maxZoom: 22,
                    onTap: (_, LatLng location) {
                      setState(() {
                        if (widget.onTap != null) {
                          widget.onTap!(location);
                        } else {
                          // Hide the tooltip if it is visible
                          tooltipKey.currentState?.deactivate();
                          // Unselect the selected bar
                          selectedBar = null;
                        }
                      });
                    }),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    tileProvider: CachedTileProvider(
                      maxStale: const Duration(days: 30),
                      store: cacheStore,
                    ),
                  ),
                  MarkerLayer(
                    markers: widget.bars.map((bar) => Marker(
                      width: 30.0,
                      height: 30.0,
                      point: bar.location,
                      child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (widget.onMarkerTap != null) {
                                    widget.onMarkerTap!(bar);
                                  } else {
                                      // Hide the tooltip if it is already visible
                                      tooltipKey.currentState?.deactivate();
                                      // Set the selected bar to the tapped bar
                                      selectedBar = bar;
                                      // Show the tooltip above the tapped marker
                                      tooltipKey.currentState?.ensureTooltipVisible();
                                  }
                                });
                              },
                              child: Tooltip(
                                // Show the tooltip programmatically if the marker is selected
                                key: selectedBar == bar || (selectedBar == null && widget.bars.indexOf(bar) == 0) ? tooltipKey : null,
                                triggerMode: TooltipTriggerMode.manual,
                                preferBelow: false,
                                showDuration: const Duration(seconds: 10),
                                textStyle: TextStyle(color: Theme.of(context).colorScheme.black),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                message: bar.name,
                                child: Image.asset(
                                  'assets/icons/map_pin.png',
                                ),
                              )
                      ),
                    ))
                        .toList(),
                  ),
                  RichAttributionWidget(
                    showFlutterMapAttribution: false,
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () =>
                            launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                ],
              ),
              if (selectedBar != null)
                Positioned(
                  bottom: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedBar!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10,),
                          Text(selectedBar!.address),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

