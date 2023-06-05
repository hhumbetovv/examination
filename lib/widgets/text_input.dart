import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText = false,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 25),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: Constants.radiusSmall,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: Constants.radiusSmall,
        ),
      ),
    );
  }
}
