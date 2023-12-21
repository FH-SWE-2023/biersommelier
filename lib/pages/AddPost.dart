import 'package:biersommelier/database/entities/Post.dart';
import 'package:flutter/material.dart';

import 'package:biersommelier/components/Post/Form.dart';
import 'package:biersommelier/router/Rut.dart';

import '../router/rut/RutPath.dart';

class AddPost extends StatelessWidget {
  final Post? post;

  const AddPost({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    // check if post is in path.arguments
    if (context.path.arguments != null && context.path.arguments["post"] != null) {
      // check if conversion is possible
      if (context.path.arguments["post"] is Post) {
        return Scaffold(
          body: PostForm(
            onSubmit: (post) async {
              context.unblockRouting();
              context.jump(RutPage.log);
            },
            initialPost: context.path.arguments["post"] as Post,
          ),
        );
      }
    }


    return Scaffold(
      body: PostForm(
        onSubmit: (post) async {
          context.unblockRouting();
          context.jump(RutPage.log);
        },
        initialPost: post,
      ),
    );
  }
}
