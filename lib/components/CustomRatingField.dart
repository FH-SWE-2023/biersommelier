import 'package:flutter/material.dart';

class CustomRatingField extends StatefulWidget {
  final int initialRating;
  final Function(int) onRatingSelected;

  const CustomRatingField({
    Key? key,
    this.initialRating = 0,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  _CustomRatingFieldState createState() => _CustomRatingFieldState();
}

class _CustomRatingFieldState extends State<CustomRatingField> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // This will align the rating to the left
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentRating = index + 1;
                });
                widget.onRatingSelected(currentRating); // Call the callback function with the new rating
              },
              child: Image.asset(
                index < currentRating
                    ? 'assets/icons/review_full.png'
                    : 'assets/icons/review_empty.png',
                width: 48, // Adjust the size as needed
              ),
            );
          }),
        ),
    );
  }
}