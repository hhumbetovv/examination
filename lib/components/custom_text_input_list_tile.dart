import 'package:examination/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late Color borderColor;
  late Color primaryColor;

  @override
  void initState() {
    super.initState();
    _localFocusNode = FocusNode();
    changeColors();
  }

  @override
  void didUpdateWidget(covariant CustomTextInputListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.incorrect != widget.incorrect) {
      changeColors();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _localFocusNode.dispose();
  }

  void changeColors() {
    setState(() {
      if (widget.incorrect) {
        borderColor = Colors.red;
        primaryColor = Colors.red;
      } else {
        borderColor = Colors.grey;
        primaryColor = Constants.answerColor;
      }
    });
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
              style: const TextStyle(fontSize: Constants.fontSizeMedium),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                focusNode: _localFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                cursorColor: primaryColor,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    widget.onChanged(int.parse(value));
                  } else {
                    widget.onChanged(null);
                  }
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: primaryColor,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: borderColor,
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: Constants.fontSizeMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
