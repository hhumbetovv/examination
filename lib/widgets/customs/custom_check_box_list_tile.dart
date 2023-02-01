import 'package:flutter/material.dart';

import '../../utils/constants.dart';

typedef BoolCallback = Function(bool? data);

class CustomCheckboxListTile extends StatefulWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.passedValue,
    required this.onValueChanged,
  });

  final String title;
  final bool passedValue;
  final BoolCallback onValueChanged;

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  bool currentValue = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.passedValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          currentValue = !currentValue;
          widget.onValueChanged(currentValue);
        });
      },
      borderRadius: Constants.radiusSmall,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: Constants.fontSizeMedium,
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: currentValue,
                onChanged: (value) {
                  setState(() {
                    currentValue = value ?? false;
                    widget.onValueChanged(currentValue);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
