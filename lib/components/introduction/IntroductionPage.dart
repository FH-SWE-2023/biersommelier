import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  final List<String> descriptions;
  final Widget preview;

  const IntroductionPage({
    super.key,
    required this.descriptions,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 8,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 290),
              child: Builder(
                builder: (context) {
                  List<Widget> items = [];
                  items.add(const SizedBox(height: 10));

                  for (String description in descriptions) {
                    items.add(
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                    items.add(const SizedBox(height: 20));
                  }

                  return Column(
                    children: items,
                  );
                },
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: preview,
          ),
        ),
      ],
    );
  }
}
