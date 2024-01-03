import 'dart:io';
import 'dart:ui' as ui;
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/ImagePicker.dart';
import 'package:biersommelier/database/entities/Beer.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:biersommelier/providers/BeerChanged.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biersommelier/components/CustomTextFormField.dart';
import 'package:biersommelier/components/Popup.dart';

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
OverlayEntry createAddBeerOverlay(BuildContext context, Function closeOverlay, Beer? initialBeer) {
  final editing = initialBeer != null;

  var beerNameController = TextEditingController(text: editing ? initialBeer!.name : "");
  final _formKey = GlobalKey<FormState>();

  // get selected image either from initial beer or set to null
  File? selectedImage;

  if (editing && initialBeer!.imageId.isNotEmpty) {
    ImageManager().getImageFileByKey(initialBeer.imageId).then((value) {
      selectedImage = value;
    });
  }

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
                title: editing ? "Bier bearbeiten" : "Bier hinzufügen",
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
                              ))),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                child: CustomTextFormField(
                                  controller: beerNameController,
                                  labelText: "Bier",
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bier muss einen Namen haben';
                                    }
                                    return null;
                                  },
                                )),
                            // Other widgets...
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Foto hinzufügen",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  ImagePicker(onImageSelected: (file) {
                                    selectedImage = file;
                                  })
                                ]),
                            const SizedBox(
                              width: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RawMaterialButton(
                                  onPressed: () async {
                                    // Check input
                                    if (_formKey.currentState!.validate()) {
                                      if (selectedImage != null) {
                                        var imageId = await ImageManager
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
                                      Provider.of<BeerChanged>(context,
                                              listen: false)
                                          .notify();
                                      closeOverlay();
                                    }
                                  },
                                  fillColor:
                                      Theme.of(context).colorScheme.success,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(6.0),
                                  constraints: const BoxConstraints(
                                      maxWidth: 48, maxHeight: 48),
                                  child: Image.asset(
                                      'assets/icons/checkmark.png',
                                      scale: 3.7),
                                ),
                                const SizedBox(width: 16),
                                RawMaterialButton(
                                  onPressed: () {
                                    showCancelConfirmationDialog(
                                        context,
                                        closeOverlay,
                                        beerNameController.text.isEmpty);
                                  },
                                  fillColor:
                                      Theme.of(context).colorScheme.error,
                                  padding: const EdgeInsets.all(6.0),
                                  constraints: const BoxConstraints(
                                      maxWidth: 48, maxHeight: 48),
                                  shape: const CircleBorder(),
                                  child: Image.asset('assets/icons/cross.png',
                                      scale: 3.7),
                                ),
                              ],
                            ),
                          ],
                        ),
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
