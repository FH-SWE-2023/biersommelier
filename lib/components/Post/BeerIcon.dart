import 'package:flutter/material.dart';

class BeerIcon extends StatelessWidget {
  final bool active;

  const BeerIcon(this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: (active
          ? Image.asset(
              'assets/post/RatingButtonOn.png',
            )
          : Image.asset(
              'assets/post/RatingButtonOff.png',
            )),
    );
  }
}
