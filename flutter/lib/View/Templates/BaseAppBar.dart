import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = const Color(0xFF45B6FE);
  final Text title = const Text(
    "SIKK RS",
    style: TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300,
    ),
  );
  final AppBar appBar;
  final List<Widget> widgets;
  final Widget leading;

  /// you can add more fields that meet your needs

  const BaseAppBar({Key key, this.leading, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
