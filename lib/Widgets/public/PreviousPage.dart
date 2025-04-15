import 'package:flutter/material.dart';

class PreviousPage extends StatelessWidget {
  final Color? iconColor;
  final Function? onPress;

  const PreviousPage({super.key, this.iconColor, this.onPress});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: iconColor ?? Colors.grey.shade700,
      ),
      onPressed: () =>
          onPress == null ? Navigator.of(context).pop() : onPress!(),
    );
  }
}
