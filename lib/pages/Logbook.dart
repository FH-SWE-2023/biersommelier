import 'package:flutter/material.dart';
import 'package:biersommelier/components/Post.dart';
import 'package:biersommelier/database/entities/Post.dart' as DBPost;
import 'package:biersommelier/components/Header.dart';

Future<List<DBPost.Post>> posts = DBPost.Post.getAll();
String phrase = "Du hast noch keine Beiträge";

class Logbook extends StatelessWidget {
  const Logbook({super.key});
   
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(

            children: [ 
              const Header(
                title: "Logbuch",
                backgroundColor: Colors.white,
                icon: HeaderIcon.none,
              ),
              //(() {
                // your code here
              //}())
              Padding(
                padding:EdgeInsets.only(top:24, bottom:24),
                
                child: 
                  FutureBuilder<List<DBPost.Post>>(
                  future: DBPost.Post.getAll(), 
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final items = snapshot.data!;

                    if(items.length == 0){
                      return Column(
                        
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                           Expanded( //Klappt noch net so gut. Text soll eigentlich zentriert sein horizontal & vertikal
                          child: Center(
                              child: Text('Noch keine Beiträge.'),
                          )
                          ),
                        ]
                      );
                      
                     
                    }
                    else{
                 
                  return ListView.builder(
                    key: PageStorageKey('PostList'),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final post = items[index];

                    return Post(
                      bar: post.bar,
                      beer: post.beer,
                      created: post.created,
                      description: post.description,
                      image: Image.network(
                        'https://th.bing.com/th/id/OIP.NUgAjHtAgYJ6UJQghyzTiAHaFj?rs=1&pid=ImgDetMain'),
                      rating: post.rating,
                    );
                    }); }
                  }
                else {
                  return const Center(child: Text('No data available'));
                }
                }) 
                ),
              ]
            )
          );
        
         
  }
}
