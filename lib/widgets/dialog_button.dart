import 'package:flutter/material.dart';

import '../utils/constants.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ??
          () {
            Navigator.of(context).pop(false);
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.red : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: Constants.radiusMedium,
        ),
      ),
      child: Text(
        text ?? 'Cancel',
        style: const TextStyle(
          fontSize: Constants.fontSizeSmall,
        ),
      ),
    );
  }
}
