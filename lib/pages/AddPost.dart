import 'package:biersommelier/components/Header.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SafeArea(
          child: Column(
        children: [
          Header(
            title: "Demo Header",
            backgroundColor: Colors.white,
            icon: HeaderIcon.add,
          ),
          Expanded(
            child: Center(
              child: Text("Post hinzufügen"),
            ),
          )
        ],
      )),
    );
  }
}
