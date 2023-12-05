import 'package:flutter/material.dart';
import 'package:biersommelier/components/Post.dart';

class Logbook extends StatelessWidget {
  const Logbook({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Center(
          child: Container(
            width: 380,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ]),
            child: Post(
              bar: 'Schmucke Veranda',
              beer: 'Leckeres Weizen',
              created: DateTime.now(),
              description: 'Dat warn spaß',
              image: Image.asset('assets/demo/Beitrag.jpg'),
              rating: 4,
            ),
          ),
        ),
      ),
    );
  }
}
