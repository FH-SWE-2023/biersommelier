import 'package:biersommelier/components/Post.dart';
import 'package:flutter/material.dart';

/// Beispielwidget für das Home Fenster
class Home extends StatelessWidget {
  const Home({super.key});

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
              image: Image.network(
                  'https://th.bing.com/th/id/OIP.NUgAjHtAgYJ6UJQghyzTiAHaFj?rs=1&pid=ImgDetMain'),
              rating: 4,
            ),
          ),
        ),
      ),
    );
  }
}
