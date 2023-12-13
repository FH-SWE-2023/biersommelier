import 'package:biersommelier/components/ActionButton.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:biersommelier/pages/AddBeer.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

import '../components/ExploreTabList.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        child: Row(
                          children: [
                            SizedBox(
                                width: 40,
                                child: Image.asset('assets/icons/addBar.png',
                                    scale: 2.1)),
                            const Text('Lokal hinzufügen'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'addBeer',
                        onTap: () {
                          OverlayEntry? addPostOverlay;
                          addPostOverlay = createAddBeerOverlay(
                              context, () => addPostOverlay?.remove());
                          Overlay.of(context).insert(addPostOverlay);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                                child: Image.asset('assets/icons/addBeer.png', scale: 3.7)),
                            const Text('Bier hinzufügen'),
                          ],
                        ),
                      ),
                    ],
                    elevation: 8.0,
                  )),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Center(
              child: ActionButton(
                onPressed: () {
                  Rut.of(context).showDialog(Popup.continueWorking(
                    pressContinue: () {
                      Rut.of(context).showDialog(null);
                    },
                    pressDelete: () {
                      Rut.of(context).rebase(RutPath.introduction());
                    },
                  ));
                },
                child: const Text('Popup anzeigen'),
              ),
            ),
          ),
          const Flexible(
            fit: FlexFit.tight,
            child: ExploreBar(),
          ),
        ],
      ),
    );
  }
}
