import 'dart:async';

import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/MapWidget.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/providers/BarChanged.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import 'package:biersommelier/components/CustomTextFormField.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:provider/provider.dart';

/// Create an overlay for adding a bar
OverlayEntry createAddBarOverlay(
    BuildContext context, Function() closeOverlay) {
  return OverlayEntry(
    opaque: true,
    builder: (context) => AddBarOverlayContent(closeOverlay: closeOverlay),
  );
}

class AddBarOverlayContent extends StatefulWidget {
  final Function() closeOverlay;

  const AddBarOverlayContent({super.key, required this.closeOverlay});

  @override
  _AddBarOverlayContentState createState() => _AddBarOverlayContentState();
}

class _AddBarOverlayContentState extends State<AddBarOverlayContent> {
  TextEditingController barNameController = TextEditingController(text: "");
  TextEditingController barAddressController = TextEditingController(text: "");
  GlobalKey<FormState> formKeyBar = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyAddress = GlobalKey<FormState>();
  Timer? _debounceAddress;
  FocusNode focusNodeAddress = FocusNode();
  /// The bars that are currently displayed on the map
  List<Bar> bars = [];
  /// Whether the user has tried to submit the form at least once
  bool submitAttempted = false;
  /// Key of the map
  GlobalKey<MapWidgetState> mapKey = GlobalKey<MapWidgetState>();

  /// GeoCode the address and update the bars list
  /// Returns true if the address is valid, false otherwise
  Future<bool> geocodeAddress(String address) async {
    try {
      List<Location> locations =
          await locationFromAddress(address, localeIdentifier: 'de_DE');
      // Use the first location
      Location location = locations.first;

      setState(() {
        bars = [
          Bar(
            id: "",
            name: "",
            location: LatLng(location.latitude, location.longitude),
            address: "",
          )
        ];
      });
      return true;
    } catch (e) {
      setState(() {
        bars = [];
      });
      return false;
    }
  }

  reverseGeocodeLatLng(double latitude, double longitude) async {
    String address;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: 'de_DE');
      // Use the first placemark
      Placemark placemark = placemarks.first;
      address = "${placemark.street}, ${placemark.postalCode} ${placemark.locality}, ${placemark.isoCountryCode}";
    } catch (e) {
      address = '$latitude, $longitude';
    }


    setState(() {
      // Temporarily remove the listener and set the address
      barAddressController.removeListener(_onBarAddressChanged);
      barAddressController.text = address;
      barAddressController.addListener(_onBarAddressChanged);
      // Update the bars list
      bars = [
        Bar(
          id: "",
          name: "",
          location: LatLng(latitude, longitude),
          address: "",
        )
      ];
      formKeyAddress.currentState!.validate();
    });
  }

  /// Called when the name field changes
  void _onBarNameChanged() {
    // If the user has tried to submit the form at least once
    if (submitAttempted) {
      // Run the validator
      formKeyBar.currentState!.validate();
    }
  }

  /// Called when the address field changes
  void _onBarAddressChanged() {
    // Debounce the address field
    if (_debounceAddress?.isActive ?? false) _debounceAddress?.cancel();
    _debounceAddress = Timer(const Duration(milliseconds: 500), () async {
      // Geocode the address
      await geocodeAddress(barAddressController.text);
      // Run the validator
      formKeyAddress.currentState!.validate();
    });
  }

  /// Called when the address field focus changes
  void _obBarAddressFocusChanged() async {
    // If the address field lost focus and the bars list is not empty
    if (!focusNodeAddress.hasFocus && bars.isNotEmpty) {
      // Move the map to the location of the bar
      mapKey.currentState?.mapController.move(bars.first.location, 13);
    }
  }

  @override
  void initState() {
    super.initState();
    barNameController.addListener(_onBarNameChanged);
    barAddressController.addListener(_onBarAddressChanged);
    focusNodeAddress.addListener(_obBarAddressFocusChanged);
  }

  @override
  void dispose() {
    barNameController.dispose();
    barAddressController.dispose();
    _debounceAddress?.cancel();
    focusNodeAddress.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Material(
        child: KeyboardDismissOnTap(
          dismissOnCapturedTaps: true,
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
                    child: MapWidget(
                      key: mapKey,
                  bars: bars,
                  onTap: (LatLng loc) {
                    reverseGeocodeLatLng(loc.latitude, loc.longitude);
                  },
                  onMarkerTap: (Bar bar) => {},
                )),
                KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  return Container(
                    color: Theme.of(context).colorScheme.white,
                    padding:
                        EdgeInsets.only(bottom: isKeyboardVisible ? 300 : 25),
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
                                    labelText: "Name",
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
                            child: const Text("Adresse",
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
                                    focusNode: focusNodeAddress,
                                    labelText: "Adresse",
                                    context: context,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Das Lokal muss einen Adresse besitzen';
                                      } else if (bars.isEmpty) {
                                        return 'Die Adresse ist ungültig';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RawMaterialButton(
                                onPressed: () async {
                                  // Run the validators on both forms
                                  bool testLokal =
                                      formKeyBar.currentState!.validate();
                                  bool testAddress =
                                      formKeyAddress.currentState!.validate();

                                  // If all fields are valid, insert the bar into the database
                                  if (testLokal && testAddress) {
                                    Bar.insert(Bar(
                                        id: Bar.generateUuid(),
                                        name: barNameController.text,
                                        location: bars.first.location,
                                        address: barAddressController.text));
                                    Provider.of<BarChanged>(context, listen: false).notify();
                                    widget.closeOverlay();
                                  } else {
                                    submitAttempted = true;
                                  }
                                },
                                fillColor: Theme.of(context).colorScheme.success,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(6.0),
                                constraints: const BoxConstraints(
                                    maxWidth: 48, maxHeight: 48),
                                child: Image.asset('assets/icons/checkmark.png',
                                    scale: 3.7),
                              ),
                              const SizedBox(width: 16),
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
                                constraints: const BoxConstraints(
                                    maxWidth: 48, maxHeight: 48),
                                shape: const CircleBorder(),
                                child: Image.asset('assets/icons/cross.png',
                                    scale: 3.7),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
              ]),
        ),
      ),
    );
  }
}

/// Show a confirmation dialog when the user tries to cancel the overlay
void showCancelConfirmationDialog(
    BuildContext context,
    Function() closeOverlay,
    bool nameIsEmpty,
    bool addressIsEmpty) {
  // If both fields are empty, close the overlay
  if (nameIsEmpty && addressIsEmpty) {
    closeOverlay();
    return;
  }
  // Otherwise, show a confirmation dialog
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
