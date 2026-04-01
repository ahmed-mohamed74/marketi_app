import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final Widget trailingWidget;
  final IconData leadingIcon;
  const ListTileWidget({
    super.key,
    required this.title,
    required this.trailingWidget, required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      trailing: trailingWidget,
    );
  }
}
