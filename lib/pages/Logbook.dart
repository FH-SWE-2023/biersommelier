import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/database/entities/Beer.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:flutter/material.dart';
import 'package:biersommelier/components/Post.dart';
import 'package:biersommelier/database/entities/Post.dart' as db_post;
import 'package:biersommelier/components/Header.dart';

Future<List<db_post.Post>> posts = db_post.Post.getAll();

class Logbook extends StatelessWidget {
  const Logbook({super.key});

  @override
  Widget build(BuildContext context) {
    ImageManager im = ImageManager();

    return SafeArea(
        child: Column(children: [
      const Header(
        title: "Logbuch",
        backgroundColor: Colors.white,
        icon: HeaderIcon.none,
      ),
      FutureBuilder<List<db_post.Post>>(
          future: db_post.Post.getAll(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final items = snapshot.data! as List<db_post.Post>;

              if (items.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Du hast noch keine Beiträge.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 2,
                          child: Image.asset(
                            'assets/icons/arrow.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                    child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final post = items[index];

                              return FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final image = snapshot.data![0] as Image;
                                      final bar = snapshot.data![1] as Bar;
                                      final beer = snapshot.data![2] as Beer;

                                      return Column(
                                        children: [
                                          Post(
                                            bar: bar.name,
                                            beer: beer.name,
                                            created: post.date,
                                            description: post.description,
                                            image: image,
                                            rating: post.rating,
                                          ),
                                          if (index != items.length - 1)
                                            const DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: Divider(
                                                      color: Colors.black)),
                                            ),
                                        ],
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                  future: Future.wait([
                                    im.getImageByKey(post.imageId),
                                    Bar.get(post.barId),
                                    Beer.get(post.beerId),
                                  ]));
                            })));
              }
            } else {
              return const Center(child: Text('No data available'));
            }
          }),
    ]));
  }
}
