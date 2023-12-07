import 'package:flutter/material.dart';
import 'package:biersommelier/components/Post.dart';
import 'package:biersommelier/database/entities/Post.dart' as DBPost;

Future<List<DBPost.Post>> posts = DBPost.Post.getAll();
String phrase = "Du hast noch keine Beiträge";

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
            child: 
              //(() {
                // your code here
              //}())
            
             FutureBuilder<List<DBPost.Post>>(
              future: DBPost.Post.getAll(), 
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final items = snapshot.data!;

                  items.map((post) {
                    Post(
                    bar: post.bar,
                    beer: post.beer,
                    created: post.created,
                    description: post.description,
                    image: Image.network(
                        'https://th.bing.com/th/id/OIP.NUgAjHtAgYJ6UJQghyzTiAHaFj?rs=1&pid=ImgDetMain'),
                    rating: post.rating,
                    );
                  }
                  );
                  return ListView.builder(
                    key: PageStorageKey(isBar ? 'BarsList' : 'BeersList'),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                    return ListTile(
                      
                    );
                    });
                  }
                }) 
              )
              )
              )
          );   
  }
}
