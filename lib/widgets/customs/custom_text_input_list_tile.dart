import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';

typedef IntCallback = void Function(int? data);

class CustomTextInputListTile extends StatefulWidget {
  const CustomTextInputListTile({
    Key? key,
    required this.title,
    required this.hintText,
    required this.onChanged,
    required this.incorrect,
  }) : super(key: key);

  final String title;
  final String hintText;
  final bool incorrect;
  final IntCallback onChanged;

  @override
  State<CustomTextInputListTile> createState() => _CustomTextInputListTileState();
}

class _CustomTextInputListTileState extends State<CustomTextInputListTile> {
  late final FocusNode _localFocusNode;
  String? error;

  @override
  void initState() {
    super.initState();
    _localFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CustomTextInputListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.incorrect != widget.incorrect) {
      setState(() {
        error = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _localFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _localFocusNode.requestFocus();
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
            SizedBox(
              width: 50,
              child: TextField(
                focusNode: _localFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (value) {
                  widget.onChanged(int.parse(value));
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  errorText: error,
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: Constants.fontSizeMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
