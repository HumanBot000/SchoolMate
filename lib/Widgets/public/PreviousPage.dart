import 'package:flutter/material.dart';

class PreviousPage extends StatelessWidget {
  final Color? iconColor;

  const PreviousPage({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: iconColor ?? Colors.grey.shade700,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
