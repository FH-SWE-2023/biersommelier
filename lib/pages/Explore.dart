import 'package:biersommelier/components/ActionButton.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:biersommelier/router/Rut.dart';
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
          const Header(
              title: "Entdecken",
              backgroundColor: Colors.white,
              icon: HeaderIcon.add),
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
                      Rut.of(context).showDialog(null);
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
