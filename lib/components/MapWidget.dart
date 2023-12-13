import 'package:biersommelier/database/entities/Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays a map with markers
/// The map is based on OpenStreetMap
/// The markers are given as a list of [LatLng]s
/// The map is cached for offline use
/// TODO: The map can be downloaded for offline use: https://fmtc.jaffaketchup.dev/bulk-downloading/introduction
class MapWidget extends StatefulWidget {
  /// A map of [LatLng]s to functions that are called when the marker is tapped
  final List<Bar> bars;

  const MapWidget({super.key, required this.bars});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Bar? selectedBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
              initialCenter: LatLng(50.775555, 6.083611),
              initialZoom: 13,
              maxZoom: 22),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
              // tileProvider: FMTC.instance('mapStore').getTileProvider(),
            ),
            MarkerLayer(
              markers: widget.bars.map((bar) => Marker(
                width: 100.0,
                height: 100.0,
                point: bar.location,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBar = bar;
                      });
                    },
                    child: Tooltip(
                      message: bar.name,
                      child: const Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                      ),
                    )),
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
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
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
  }
}

