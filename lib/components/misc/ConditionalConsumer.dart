import 'package:biersommelier/providers/PostChanged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biersommelier/providers/BarChanged.dart';
import 'package:biersommelier/providers/BeerChanged.dart';

/// Conditionally wraps the provided [builder] with a Consumer based on the [type]
class ConditionalConsumer extends StatelessWidget {
  final ConsumerType type;
  final Function(BuildContext context) builder;

  const ConditionalConsumer({super.key, required this.type, required this.builder});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ConsumerType.beer:
        return Consumer<BeerChanged>(builder: (context, _, __) => builder(context));
      case ConsumerType.bar:
        return Consumer<BarChanged>(builder: (context, _, __) => builder(context));
      case ConsumerType.post:
        return Consumer<PostChanged>(builder: (context, _, __) => builder(context));
    }
  }
}

enum ConsumerType {
  beer,
  bar,
  post
}