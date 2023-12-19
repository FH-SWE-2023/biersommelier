import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/MapWidget.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:biersommelier/components/CustomTextFormField.dart';
import 'package:biersommelier/components/Popup.dart';

/// Close the overlay and show a confirmation dialog if the user has entered
/// data in the text fields
void showCancelConfirmationDialog(BuildContext context, Function closeOverlay,
    bool nameIsEmpty, bool adressIsEmpty) {
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

/// Create an overlay for adding a bar
OverlayEntry createAddBarOverlay(BuildContext context, Function closeOverlay) {
  return OverlayEntry(
    opaque: true,
    builder: (context) => AddBarOverlayContent(closeOverlay: closeOverlay),
  );
}

class AddBarOverlayContent extends StatefulWidget {
  final Function closeOverlay;

  AddBarOverlayContent({super.key, required this.closeOverlay});

  @override
  _AddBarOverlayContentState createState() => _AddBarOverlayContentState();
}

class _AddBarOverlayContentState extends State<AddBarOverlayContent> {
  TextEditingController barNameController = TextEditingController(text: "");
  TextEditingController barAddressController = TextEditingController(text: "");
  GlobalKey<FormState> formKeyBar = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyAddress = GlobalKey<FormState>();
  List<Bar> bars = [];

  @override
  void initState() {
    super.initState();
    barAddressController.addListener(() {
      var latLong = barAddressController.text.split(',');
      var lat = double.parse(latLong[0]);
      var long = double.parse(latLong[1]);
      setState(() {
        bars = [
          Bar(
            id: Bar.generateUuid(),
            name: barNameController.text,
            location: LatLng(lat, long),
            address: barAddressController.text,
          )
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Header(
                title: "Lokal hinzufügen",
                backgroundColor: Theme.of(context).colorScheme.white,
                icon: HeaderIcon.back,
                onBack: () {
                  showCancelConfirmationDialog(
                      context,
                      widget.closeOverlay,
                      barNameController.text.isEmpty,
                      barAddressController.text.isEmpty);
                },
              ),
              Expanded(
                  child: Material(
                      child: MapWidget(
                bars: bars,
                onTap: (LatLng loc) => {
                  setState(() => barAddressController.text =
                      '${loc.latitude}, ${loc.longitude}')
                },
                onMarkerTap: (Bar bar) => {},
              ))),
              Material(
                child: Container(
                  color: Theme.of(context).colorScheme.white,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                          alignment: Alignment.topLeft,
                          child: const Text("Lokal",
                              style: TextStyle(
                                fontSize: 16,
                              ))),
                      Form(
                        key: formKeyBar,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                child: CustomTextFormField(
                                  controller: barNameController,
                                  //Dier Teil wird nicht benutzt
                                  decoration:
                                      const InputDecoration(labelText: "Lokal"),
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Das Lokal muss einen Namen haben';
                                    }
                                    return null;
                                  },
                                )),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                          alignment: Alignment.topLeft,
                          child: const Text("Addresse",
                              style: TextStyle(
                                fontSize: 16,
                              ))),
                      Form(
                        key: formKeyAddress,
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                child: CustomTextFormField(
                                  controller: barAddressController,
                                  decoration: const InputDecoration(
                                      labelText: "Addresse"),
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Das Lokal muss einen Addresse besitzen';
                                    }
                                    return null;
                                  },
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            onPressed: () async {
                              // Validate all fields
                              bool testLokal =
                                  formKeyBar.currentState!.validate();
                              bool testAddress =
                                  formKeyAddress.currentState!.validate();

                              // If all fields are valid, insert the bar into the database
                              if (testLokal && testAddress) {
                                Bar.insert(Bar(
                                    id: Bar.generateUuid(),
                                    name: barNameController.text,
                                    location: bars[0].location,
                                    address: barAddressController.text));
                                widget.closeOverlay();
                              }
                            },
                            fillColor: Theme.of(context).colorScheme.success,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset('assets/icons/checkmark.png',
                                scale: 3.7),
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              showCancelConfirmationDialog(
                                  context,
                                  widget.closeOverlay,
                                  barNameController.text.isEmpty,
                                  barAddressController.text.isEmpty);
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
            ]),
      ),
    );
  }
}
