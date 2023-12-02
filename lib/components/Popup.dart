import 'package:biersommelier/components/popup/Option.dart';
import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final List<Option> options;
  final Function()? onAbort;

  const Popup({super.key, required this.options, this.onAbort});

  static continueWorking({Function()? pressContinue, Function()? pressDelete}) {
    return Popup(
      options: [
        Option(
          icon: 'assets/popup/Pen.png',
          label: 'Weiter bearbeiten',
          color: Colors.black,
          callback: pressContinue,
        ),
        Option(
          icon: 'assets/popup/Delete.png',
          label: 'Änderung löschen',
          color: Colors.red[900],
          callback: pressDelete,
        ),
      ],
      onAbort: pressContinue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onAbort,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
            child: Container(),
          ),
        ),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 5,
                  offset: const Offset(1, 0),
                ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Builder(
                builder: (context) {
                  List<Widget> list = [];

                  for (Option option in options) {
                    list.add(
                      TextButton.icon(
                        onPressed: option.callback,
                        icon: Image.asset(
                          option.icon,
                          width: 23,
                          height: 23,
                          fit: BoxFit.cover,
                        ),
                        label: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 17,
                            color: option.color,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: list,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
