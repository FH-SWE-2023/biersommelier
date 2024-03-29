import 'dart:math';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:biersommelier/router/rut/RutExtension.dart';
import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/database/entities/Beer.dart';

class BeerCaptain extends StatefulWidget {
  const BeerCaptain({super.key});

  @override
  _BeerCaptainState createState() => _BeerCaptainState();
}

class _BeerCaptainState extends State<BeerCaptain> {
  int barRandom = 0;
  int beerRandom = 0;

  bool show = false;

  late List<Bar> bars;
  late List<Beer> beers;

  @override
  void initState() {
    super.initState();
    Bar.getAll().then((value) => bars = value);
    Beer.getAll().then((value) => beers = value);
  }

  void generate() {
    if (bars.isEmpty || beers.isEmpty) {
      context.showToast(
        Toast.levelToast(
          message: "Lokal- oder Bierliste leer",
          level: ToastLevel.warning,
        ),
      );
      return;
    }
    setState(() {
      //enable showing UICards
      show = true;

      //Generate random number for bar based on amount of entries in DB
      barRandom = Random().nextInt(bars.length);

      //Generate random number for beer based on amount of entries in DB
      beerRandom = Random().nextInt(beers.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(
                title: "Bierkapitän",
                backgroundColor: Colors.white,
                icon: HeaderIcon.none,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Image(image: AssetImage('assets/demo/Beercaptain.png')),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              0, -10), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: generate,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        foregroundColor: Theme.of(context).colorScheme.white,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text(
                        'Generieren',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 120,
            child: Column(
                children: !show
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 48, top: 56, right: 48, bottom: 63),
                          child: Text(
                            "Der Bierkapitän gibt dir Empfehlungen, welches Lokal und Bier du probieren könntest.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.fontSize),
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 48, top: 16, right: 48),
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: null,
                                  title: Text(bars[barRandom].name),
                                  subtitle: Text(bars[barRandom].address),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.displayMedium,
                                  textColor: Colors.black,
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  subtitle: const Text(""),
                                  title: Container(
                                      transform:
                                          Matrix4.translationValues(0, 8, 0),
                                      child: Text(beers[beerRandom].name)),
                                  leading: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: FutureBuilder<Image>(
                                      future: ImageManager.getImageByKey(
                                          beers[beerRandom].imageId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Image> imageSnapshot) {
                                        if (imageSnapshot.connectionState ==
                                                ConnectionState.done &&
                                            imageSnapshot.hasData) {
                                          return imageSnapshot.data!;
                                        } else if (imageSnapshot.hasError) {
                                          return const Icon(Icons.error);
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
          ),
        ],
      ),
    );
  }
}
