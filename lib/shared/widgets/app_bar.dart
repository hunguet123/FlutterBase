import 'package:flutter/material.dart';

/// A common [AppBar] for the entire app.
/// Implements [PreferredSizeWidget] so it can be used in [Scaffold.appBar].
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    required this.title,
    super.key,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
