import 'package:biersommelier/components/Popup/Option.dart';
import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final List<Option> options;
  final Function()? onAbort;
  final String? description;

  const Popup(
      {super.key, required this.options, this.onAbort, this.description});

  static continueWorking({Function()? pressContinue, Function()? pressDelete}) {
    return Popup(
      options: [
        Option(
          icon: 'assets/icons/pen_black.png',
          label: 'Weiter bearbeiten',
          color: Colors.black,
          callback: pressContinue,
        ),
        Option(
          icon: 'assets/icons/delete.png',
          label: 'Änderung löschen',
          color: Colors.red[900],
          callback: pressDelete,
        ),
      ],
      onAbort: pressContinue,
    );
  }

  static deleteFavorite({Function()? pressDelete, Function()? onAbort}) {
    return Popup(
      options: [
        Option(
          icon: 'assets/icons/delete.png',
          label: 'Favorit Löschen',
          color: Colors.red[900],
          callback: pressDelete,
        ),
      ],
      onAbort: onAbort,
    );
  }

  // popup for edit, favorite, delete -> user can also give string for title and bool for favorite
  static editExplore(
      {Function()? pressEdit,
      Function()? pressFavorite,
      Function()? pressDelete,
      Function()? onAbort,
      required String title,
      bool favorite = false}) {
    return Popup(
      options: [
        Option(
          icon: 'assets/icons/pen_black.png',
          label: '$title bearbeiten',
          color: Colors.black,
          callback: pressEdit,
        ),
        Option(
          icon: 'assets/icons/heart.png',
          label: favorite ? 'Favorit entfernen' : 'Favorisieren',
          color: Colors.black,
          callback: pressFavorite,
        ),
        Option(
          icon: 'assets/icons/delete.png',
          label: '$title löschen',
          color: Colors.red[900],
          callback: pressDelete,
        ),
      ],
      onAbort: onAbort,
    );
  }

  static editLogbook(
      {Function()? pressEdit, Function()? pressDelete, Function()? onAbort}) {
    return Popup(
      options: [
        Option(
          icon: 'assets/icons/pen_black.png',
          label: 'Beitrag bearbeiten',
          color: Colors.black,
          callback: pressEdit,
        ),
        Option(
          icon: 'assets/icons/delete.png',
          label: 'Beitrag löschen',
          color: Colors.red[900],
          callback: pressDelete,
        ),
      ],
      onAbort: onAbort,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      description != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                description!,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ))
                          : const SizedBox(width: 0, height: 0),
                      Builder(
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
