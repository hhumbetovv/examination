import 'package:examination/constants.dart';
import 'package:examination/model/question_controller.dart';
import 'package:examination/model/settings.dart';
import 'package:flutter/material.dart';

typedef TypeCallback = void Function(QuestionTypes type);

class CustomRadioListTile extends StatefulWidget {
  const CustomRadioListTile({
    super.key,
    required this.controller,
    required this.group,
    required this.changeSelectedSettings,
  });

  final QuestionController controller;
  final String group;
  final TypeCallback changeSelectedSettings;

  @override
  State<CustomRadioListTile> createState() => _CustomRadioListTileState();
}

class _CustomRadioListTileState extends State<CustomRadioListTile> {
  late QuestionTypes selectedSettingsType;

  @override
  void initState() {
    super.initState();
    selectedSettingsType = widget.controller.currentSettings.type;
  }

  InkWell selection(String selectionTitle, QuestionTypes selection) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSettingsType = selection;
          widget.changeSelectedSettings(selection);
        });
      },
      borderRadius: Constants.radiusSmall,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectionTitle,
              style: const TextStyle(fontSize: Constants.fontSizeMedium),
            ),
            Transform.scale(
              scale: 1.2,
              child: Radio<QuestionTypes>(
                activeColor: Constants.answerColor,
                value: selection,
                groupValue: selectedSettingsType,
                onChanged: (QuestionTypes? value) {
                  setState(() {
                    selectedSettingsType = value ?? QuestionTypes.all;
                    widget.changeSelectedSettings(selection);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selection(widget.controller.typeList[0], QuestionTypes.values[0]),
        selection(widget.controller.typeList[1], QuestionTypes.values[1]),
        selection(widget.controller.typeList[2], QuestionTypes.values[2]),
      ],
    );
  }
}
