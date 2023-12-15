import 'package:biersommelier/components/DropdownInputField.dart';
import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/database/entities/Post.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/entities/Bar.dart';

import 'package:biersommelier/components/Post/Form.dart';
import 'package:biersommelier/router/Rut.dart';

import '../router/rut/RutPath.dart';

class AddPost extends StatelessWidget {
  final Post? post;

  const AddPost({super.key, this.post});

  @override
  Widget build(BuildContext context) {
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
