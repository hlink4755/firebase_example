
import 'package:flutter/material.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size preferredSize;
  final Widget title;
  Widget? leading;
  bool? centerTitle;
  final bool automaticallyImplyLeading;
  List<Widget>? actions;
  Color? backgroundColor;
  BaseAppbar({super.key,this.centerTitle, this.actions,this.leading,required this.title,required this.automaticallyImplyLeading, this.preferredSize = const Size.fromHeight(kToolbarHeight),this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }
}
