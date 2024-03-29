import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/question_controller.dart';
import '../../model/settings.dart';
import '../customs/custom_check_box_list_tile.dart';
import '../customs/custom_radio_list_tile.dart';
import '../customs/custom_text_input_list_tile.dart';
import '../dialog_button.dart';

Future<bool?> settingsModal(BuildContext context, QuestionController controller) async {
  if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
    return showModalSideSheet<bool>(
      context: context,
      withCloseControll: false,
      body: _CustomBottomSheet(
        controller: controller,
      ),
    );
  }
  return showModalBottomSheet<bool>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Theme.of(context).colorScheme.background,
    builder: ((context) {
      return _CustomBottomSheet(
        controller: controller,
      );
    }),
  );
}

class _CustomBottomSheet extends StatefulWidget {
  const _CustomBottomSheet({required this.controller});

  final QuestionController controller;

  @override
  State<_CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<_CustomBottomSheet> {
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

  @override
  void dispose() {
    super.dispose();
  }

  //! Change Selected Setting's Type
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

  //! Check Entered Indexes
  void checkIndexes() {
    setState(() {
      incorrect = selectedSettings.checkIndexes(
        indexSetting.firstIndex ?? selectedSettings.firstIndex,
        indexSetting.lastIndex ?? selectedSettings.lastIndex,
      );
    });
  }

  //! Change Current Setting's Random
  void changeRandom(bool value) {
    random = value;
  }

  //! Save all values and reset
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

  //! Dialog
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Type Setting
            CustomRadioListTile(
              controller: widget.controller,
              group: 'type',
              changeSelectedSettings: (type) => changeSelectedSettings(type),
            ),
            const Divider(),
            //! Index Setting
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
            //! Random Setting
            CustomCheckboxListTile(
              title: 'Random',
              passedValue: random,
              onValueChanged: (value) => changeRandom(value ?? false),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: DialogButton()),
                const SizedBox(width: 10),
                Expanded(
                  child: DialogButton(
                    onPressed: () {
                      checkIndexes();
                      saveSettings();
                    },
                    text: 'Reset',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//! Index Settings
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
