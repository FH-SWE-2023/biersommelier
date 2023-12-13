import 'dart:io';
import 'dart:ui' as ui;
import 'package:biersommelier/components/CustomTextField.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  File? selectedImage;
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
                    children: [
                      TextFieldWithLabel(
                          label: "Lokal",
                          textField: CustomTextField(
                            context: context,
                            controller: barNameController,
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldWithLabel(
                                    label: "Adresse",
                                    textField: CustomTextField(
                                      context: context,
                                      controller: barAdressController,
                                    )),
                              ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            onPressed: () async {
                              if(barNameController.text.isNotEmpty && barAdressController.text.isNotEmpty) {
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
            ],
          ),
        ),
      ),
    ),
  );
}
