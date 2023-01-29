import 'package:examination/components/bordered_container.dart';
import 'package:examination/components/custom_check_box_list_tile.dart';
import 'package:examination/components/custom_radio_list_tile.dart';
import 'package:examination/components/custom_text_input_list_tile.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/question_controller.dart';
import 'package:examination/model/settings.dart';
import 'package:flutter/material.dart';

Future<bool?> settingsDialog(BuildContext context, QuestionController controller) async {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return _CustomAlertDialog(
        controller: controller,
      );
    }),
  );
}

class _CustomAlertDialog extends StatefulWidget {
  const _CustomAlertDialog({required this.controller});

  final QuestionController controller;

  @override
  State<_CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<_CustomAlertDialog> {
  late Settings selectedSettings;
  bool incorrect = false;
  bool random = false;
  IndexSetting indexSetting = IndexSetting();

  @override
  void initState() {
    super.initState();
    selectedSettings = widget.controller.currentSettings;
    indexSetting.initIndexes();
    random = selectedSettings.random;
  }

  void changeSelectedSettings(QuestionTypes type) {
    setState(() {
      if (type == QuestionTypes.all) {
        selectedSettings = widget.controller.allQuestionSettings;
      } else if (type == QuestionTypes.longs) {
        selectedSettings = widget.controller.longAnswerQuestionSettings;
      } else if (type == QuestionTypes.shorts) {
        selectedSettings = widget.controller.shortAnswerQuestionSettings;
      }
    });
  }

  void changeRandom(bool value) {
    setState(() {
      random = value;
    });
  }

  void checkIndexes() {
    setState(() {
      incorrect = selectedSettings.checkIndexes(
        indexSetting.firstIndex ?? selectedSettings.firstIndex,
        indexSetting.lastIndex ?? selectedSettings.lastIndex,
      );
    });
  }

  void saveSettings() {
    if (!incorrect) {
      selectedSettings.setIndexSettings(
        indexSetting.firstIndex,
        indexSetting.lastIndex,
        indexSetting.count,
      );
      widget.controller.changeSettings(selectedSettings.type);
      widget.controller.currentSettings.setRandom(random);
      Navigator.of(context).pop(true);
    }
  }

  SizedBox dialogButton({bool cancel = false}) {
    void onPressed() {
      if (cancel) {
        Navigator.of(context).pop(false);
      } else {
        checkIndexes();
        saveSettings();
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cancel ? Colors.red : Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: Constants.radiusMedium,
          ),
        ),
        child: Text(cancel ? 'CANCEL' : 'RESET'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: Constants.radiusLarge),
      contentPadding: const EdgeInsets.all(10),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: BorderedContainer(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomRadioListTile(
                controller: widget.controller,
                group: 'type',
                changeSelectedSettings: (type) => changeSelectedSettings(type),
              ),
              const Divider(),
              CustomTextInputListTile(
                title: 'First index',
                hintText: '${selectedSettings.firstIndex + 1}',
                onChanged: (value) {
                  indexSetting.setFirstIndex(value != null ? value - 1 : value);
                },
                incorrect: incorrect,
              ),
              CustomTextInputListTile(
                title: 'Last index',
                hintText: '${selectedSettings.lastIndex + 1}',
                onChanged: (value) {
                  indexSetting.setLastIndex(value != null ? value - 1 : value);
                },
                incorrect: incorrect,
              ),
              CustomTextInputListTile(
                title: 'Count',
                hintText: '${selectedSettings.count}',
                onChanged: (value) {
                  indexSetting.setCount(value);
                },
                incorrect: false,
              ),
              const Divider(),
              CustomCheckboxListTile(
                title: 'Random',
                passedValue: random,
                onValueChanged: (value) => changeRandom(value ?? false),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        dialogButton(cancel: true),
        dialogButton(),
      ],
    );
  }
}

class IndexSetting {
  int? firstIndex;
  int? lastIndex;
  int? count;
  bool isFirstIndexEmpty = true;
  bool isLastIndexEmpty = true;
  bool isCountEmpty = true;

  void initIndexes() {
    firstIndex = null;
    lastIndex = null;
    count = null;
  }

  void setFirstIndex(int? index) {
    firstIndex = index;
  }

  void setLastIndex(int? index) {
    lastIndex = index;
  }

  void setCount(int? count) {
    this.count = count;
  }
}
