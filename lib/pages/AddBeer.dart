import 'dart:io';
import 'dart:ui' as ui;
import 'package:biersommelier/components/CustomTextField.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/ImagePicker.dart';
import 'package:biersommelier/database/entities/Beer.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';

import '../components/CustomTextFormField.dart';
import '../components/Popup.dart';
import '../router/rut/RutPath.dart';

///
/// Funktion to Close the add Beer Overlay with warning Dialog
///
void showCancelConfirmationDialog(
    BuildContext context, Function closeOverlay, bool formIsEmpty) {
  if (formIsEmpty) {
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
/// Overlay to add a Beer
///
OverlayEntry createAddBeerOverlay(BuildContext context, Function closeOverlay) {
  var beerNameController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
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
                title: "Bier hinzufügen",
                backgroundColor: Theme.of(context).colorScheme.white,
                icon: HeaderIcon.back,
                onBack: () {
                  showCancelConfirmationDialog(
                      context, closeOverlay, beerNameController.text.isEmpty);
                  //Go Back
                },
              ),
              Material(
                child: Container(
                  color: Theme.of(context).colorScheme.white,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: [
                      // Labe for Bier Textfield
                      Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                          alignment: Alignment.topLeft,
                          child: const Text("Bier",
                              style: TextStyle(
                                  fontSize: 16,
                              )
                      )),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              child: CustomTextFormField(
                                controller: beerNameController,
                                //Dier Teil wird nicht benutzt
                                decoration: const InputDecoration(
                                  labelText: "Bier"
                                ),
                                context: context,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Foto hinzufügen",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ),
                                    ImagePickerWidget(onImageSelected: (file) {
                                      selectedImage = file;
                                    })
                                  ])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RawMaterialButton(
                                onPressed: () async {
                                  // Check input
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedImage != null) {
                                      var imageId = await ImageManager()
                                          .saveImage(selectedImage!);
                                      Beer.insert(Beer(
                                          id: Beer.generateUuid(),
                                          name: beerNameController.text,
                                          imageId: imageId));
                                    } else {
                                      Beer.insert(Beer(
                                          id: Beer.generateUuid(),
                                          name: beerNameController.text,
                                          imageId: ""));
                                    }
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
                                      beerNameController.text.isEmpty);
                                },
                                fillColor: Theme.of(context).colorScheme.error,
                                padding: const EdgeInsets.all(6.0),
                                shape: const CircleBorder(),
                                child: Image.asset('assets/icons/cross.png',
                                    scale: 3.7),
                              ),
                            ],
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
