import 'package:flutter/material.dart';

import '../components/ExploreTabList.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Explore',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ExploreBar(),
          ),
        ],
      ),
    );
  }
}
