import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/ExploreTabList.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(
            title: "Entdecken",
            backgroundColor: Colors.white,
            icon: HeaderIcon.add),
        Expanded(
            child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(50.775555, 6.083611),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            RichAttributionWidget(
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        )),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
                clipBehavior: Clip.hardEdge,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ExploreBar()),
            Positioned.fill(
              top: -20,
              child: Align(
                alignment: Alignment.topCenter,
                child: RawMaterialButton(
                    onPressed: () => {},
                    elevation: 2.0,
                    fillColor: Theme.of(context).colorScheme.white,
                    padding: const EdgeInsets.all(3.0),
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40.0,
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }
}
