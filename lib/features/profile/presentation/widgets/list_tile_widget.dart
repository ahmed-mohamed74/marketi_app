import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final Widget trailingWidget;
  final IconData leadingIcon;
  final VoidCallback onTab;
  const ListTileWidget({
    super.key,
    required this.title,
    required this.trailingWidget, required this.leadingIcon, required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTab,
      leading: Icon(leadingIcon),
      title: Text(title),
      trailing: trailingWidget,
    );
  }
}
