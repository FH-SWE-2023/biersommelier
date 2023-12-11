//import 'package:biersommelier/components/ActionButton.dart';
import 'dart:math';
import '../imagemanager/ImageManager.dart';
import 'package:biersommelier/components/Toast.dart';
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

  final ImageManager imageManager = ImageManager();

  late List<Bar> bars;
  late List<Beer> beers;

  @override
  void initState() {
    super.initState();
    Bar.getAll().then((value) => bars = value);
    Beer.getAll().then((value) => beers = value);
  }

  void generate(){
    if(bars.isEmpty || beers.isEmpty){
      showToast(context, "Lokal- oder Bierliste leer", ToastLevel.warning);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(
            title: "Bierkapitän",
            backgroundColor: Colors.white,
            icon: HeaderIcon.none,
          ),
          Column(
            children: !show ? [
              Padding(
                    padding: const EdgeInsets.only(left: 48, top: 56, right: 48, bottom: 63),
                    
                      child: Text(
                        "Der Bierkapitän gibt dir Empfehlungen, welches Lokal und Bier du probieren könntest.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                        ),
                        ),
              ), 
            ] : [
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 16, right: 48),
                child: Column(
                  children: [
                    Card(
                      child:
                        ListTile(
                          leading: null,
                          title: Text(bars[barRandom].name),
                          subtitle: Text(bars[barRandom].address),
                        ), 
                    ),
                    Card(
                      child:
                        ListTile(
                          subtitle: Text(""),
                          title: Text(beers[beerRandom].name),
                          leading: FutureBuilder<Image>(
                            future: imageManager.getImageByKey(beers[beerRandom].imageId),
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
                          ), 
                                                                       
                      )
                  ],
                ),
              )
            ]
          ),
          const Image(image: AssetImage('assets/demo/Beercaptain.png')),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom:8),
            decoration: BoxDecoration(
               boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: Offset(0, -10), // changes position of shadow
                  ),
                ],
            ),
              child: TextButton(
                onPressed: generate, 
                style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text('Generieren',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
             ),
          ),
        ],
      ),
    );
  }
}
