import 'package:biersommelier/components/DropdownInputField.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/entities/Bar.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
          child: Column(
        children: [
          const Header(
            title: "Demo Header",
            backgroundColor: Colors.white,
            icon: HeaderIcon.add,
          ),
          Expanded(
            child: Center(
                child: DropdownInputField(
              optionsList: [
                Bar(
                    name: "Billiard Bar Downtown",
                    address: "Viktoriastraße Einundneunzig Viel",
                    id: '1',
                    location: LatLng(0, 0)),
                Bar(
                    name: "Billiard Verein Aachen",
                    address: "Rote Sträse 39",
                    id: '2',
                    location: LatLng(0, 0)),
                Bar(
                    name: "Lach Club Aachen",
                    address: "Penisweg 3",
                    id: '3',
                    location: LatLng(0, 0)),
                Bar(
                    name: "Mizu Bar Aachen",
                    address: "Oralinastraße 69",
                    id: '4',
                    location: LatLng(0, 0)),
                Bar(
                    name: "Ver-pufft",
                    address: "Kiffstraße 420",
                    id: '4',
                    location: LatLng(0, 0)),
              ],
              labelText: "Name",
              onBarSelected: (Bar selectedBar) {
                print('Selected bar: ${selectedBar.name}');
              },
            )),
          )
        ],
      )),
    );
  }
}
