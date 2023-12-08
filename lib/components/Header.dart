import 'package:flutter/material.dart';

enum HeaderIcon { back, add, none }

///Custom App Bar with Custom Title[title] and Custom Background Color[backgroundColor].
///
///To show the Back-Arrow the bool [showBackArrow] can be set
///To show the Add-Button the bool [showAdd] can be set
class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final HeaderIcon icon;

  final Function()? onBack;
  final Function()? onAdd;

  const Header({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.icon,
    this.onBack,
    this.onAdd,
  });

  @override
  Size get preferredSize => const Size.fromHeight(75.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 29.0, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: icon == HeaderIcon.add
          ? <Widget>[
              IconButton(
                icon: const Icon(Icons.add, size: 33.0),
                onPressed: () {
                  if (onAdd != null) {
                    onAdd!();
                  }
                },
                color: Colors.black,
              )
            ]
          : null,
      leading: icon == HeaderIcon.back
          ? IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 45.0,
              ),
              onPressed: () {
                if (onBack != null) {
                  onBack!();
                } else {
                  Navigator.pop(context);
                }
              },
              color: Colors.black,
            )
          : null,
      toolbarHeight: 75,
      backgroundColor: backgroundColor,
    );
  }
}
