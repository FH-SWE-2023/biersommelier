import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProgressIntroductionIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final Function()? onPressed;

  const ProgressIntroductionIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: count,
              axisDirection: Axis.horizontal,
              effect: const ColorTransitionEffect(
                dotColor: Color(0xFFEEEEEE),
                activeDotColor: Color(0xFF202020),
                dotHeight: 12,
                dotWidth: 12,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.chevron_right, size: 40),
            ),
          )
        ],
      ),
    );
  }
}
