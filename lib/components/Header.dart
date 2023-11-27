import 'package:flutter/material.dart';

///Custom App Bar with Custom Title[title] and Custom Background Color[backgroundColor].
///
///To show the Back-Arrow the bool [showBackArrow] can be set
///To show the Add-Button the bool [showAdd] can be set
class Header extends StatelessWidget implements 
PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool showBackArrow;
  final bool showAdd;

  const Header({
    super.key, 
    required this.title, 
    required this.backgroundColor,
    required this.showBackArrow,
    required this.showAdd,
  });

  @override
  Size get preferredSize => const Size.fromHeight(75.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
      style: const TextStyle(color: Colors.black, fontSize: 29.0, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: showAdd
      ?
      <Widget>[
        IconButton(
          icon: const Icon(Icons.add, size: 33.0),
          onPressed: () {},
          color: Colors.black,
        )
      ]
      : null, 
      leading: showBackArrow
        ? IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 45.0,),
           onPressed: () {
            //Navigator.pop(context);
            //context.jump(RutPage.home);
          },
          color: Colors.black,
        )
      : null,
      toolbarHeight: 75,
      backgroundColor: backgroundColor,
    );
  }
}