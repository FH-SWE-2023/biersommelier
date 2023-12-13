import 'dart:io';
import 'dart:ui' as ui;
import 'package:biersommelier/components/CustomTextField.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/CustomTextFormField.dart';
import '../components/Popup.dart';
import '../router/rut/RutPath.dart';

///
/// Function to Close the add Bar Overlay with warning Dialog
///
void showCancelConfirmationDialog(
    BuildContext context, Function closeOverlay, bool nameIsEmpty, bool adressIsEmpty) {
  if (nameIsEmpty && adressIsEmpty) {
    closeOverlay();
    return;
  }
  OverlayEntry? popUpOverlay;
  popUpOverlay = OverlayEntry(
      opaque: false,
      maintainState: false,
      builder: (context) => Popup.continueWorking(pressContinue: () {
            popUpOverlay?.remove();
          }, pressDelete: () {
            popUpOverlay?.remove();
            closeOverlay();
          }));
  Overlay.of(context).insert(popUpOverlay);
}

///
/// Overlay to add a Bar
///
OverlayEntry createAddBarOverlay(BuildContext context, Function closeOverlay) {
  var barNameController = TextEditingController(text: "");
  var barAdressController = TextEditingController(text: "");
  final _formKeyLokal = GlobalKey<FormState>();
  final _formKeyAdress = GlobalKey<FormState>();

  return OverlayEntry(
    opaque: false,
    builder: (context) => Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Header(
                title: "Lokal hinzufügen",
                backgroundColor: Theme.of(context).colorScheme.white,
                icon: HeaderIcon.back,
                onBack: () {
                  showCancelConfirmationDialog(
                      context, closeOverlay, barNameController.text.isEmpty, barAdressController.text.isEmpty);
                },
              ),
              Material(
                child: Container(
                  color: Theme.of(context).colorScheme.white,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    //barNameController
                  children: [
                  // Labe for Lokal Textfield
                  Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                    alignment: Alignment.topLeft,
                    child: const Text("Lokal",
                        style: TextStyle(
                          fontSize: 16,
                        )
                    )),
                      Form(
                        key: _formKeyLokal,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                child: CustomTextFormField(
                                  controller: barNameController,
                                  //Dier Teil wird nicht benutzt
                                  decoration: const InputDecoration(
                                      labelText: "Lokal"
                                  ),
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Das Lokal muss einen Namen haben';
                                    }
                                    return null;
                                  },
                                )
                            ),
                            // Other widgets...
                          ],
                        ),
                      ),

                    Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                        alignment: Alignment.topLeft,
                        child: const Text("Adresse",
                            style: TextStyle(
                              fontSize: 16,
                            )
                        )),
                    Form(
                      key: _formKeyAdress,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              child: CustomTextFormField(
                                controller: barAdressController,
                                //Dier Teil wird nicht benutzt
                                decoration: const InputDecoration(
                                    labelText: "Adresse"
                                ),
                                context: context,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Das Lokal muss einen Adresse besitzen';
                                  }
                                  return null;
                                },
                              )
                          ),
                          // Other widgets...
                        ],
                      ),
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            onPressed: () async {
                              // check all input
                              bool testLokal = _formKeyLokal.currentState!.validate();
                              bool testAdress = _formKeyAdress.currentState!.validate();

                              // checking input and wirte in database
                              if(testLokal && testAdress) {
                                LatLng emptyLatLng = const LatLng(0, 0);

                                Bar.insert(Bar(
                                    id: Bar.generateUuid(),
                                    name: barNameController.text,
                                    location: emptyLatLng,
                                    address: barAdressController.text
                                  )
                                );
                                closeOverlay();
                              }
                            },
                            fillColor:
                                Theme.of(context).colorScheme.success,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset('assets/icons/checkmark.png',
                                scale: 3.7),
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              showCancelConfirmationDialog(
                                  context,
                                  closeOverlay,
                                  barNameController.text.isEmpty,
                                  barAdressController.text.isEmpty);
                            },
                            fillColor: Theme.of(context).colorScheme.error,
                            padding: const EdgeInsets.all(6.0),
                            shape: const CircleBorder(),
                            child: Image.asset('assets/icons/cross.png',
                                scale: 3.7),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )

        ]
        ),
        ),
      ),
    ),
  );
}
