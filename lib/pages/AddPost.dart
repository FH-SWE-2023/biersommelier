import 'package:flutter/material.dart';

import 'package:biersommelier/components/Post/Form.dart';
import 'package:biersommelier/router/Rut.dart';

import '../router/rut/RutPath.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostForm(
        onSubmit: (post) async {
          context.unblockRouting();
          context.jump(RutPage.log);
        },
      ),
    );
  }
}
