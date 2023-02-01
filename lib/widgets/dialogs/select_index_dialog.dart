import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/question_controller.dart';
import '../../utils/constants.dart';
import '../bordered_container.dart';
import '../dialog_button.dart';

Future<bool?> selectIndexDialog(BuildContext context, QuestionController controller) async {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      int newIndex = controller.currentIndex;

      //! Dialog
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: BorderedContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    newIndex = controller.currentIndex;
                    if (value.isNotEmpty) newIndex = int.parse(value) - 1;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '${controller.currentIndex + 1}',
                  ),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: Constants.fontSizeLarge,
                  ),
                ),
              ),
              const Text(
                ' / ',
                style: TextStyle(
                  fontSize: Constants.fontSizeLarge,
                ),
              ),
              Expanded(
                child: Text(
                  '${controller.currentSettings.count}',
                  style: const TextStyle(
                    fontSize: Constants.fontSizeLarge,
                  ),
                ),
              )
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              const Expanded(child: DialogButton()),
              const SizedBox(width: 10),
              Expanded(
                child: DialogButton(
                  onPressed: () {
                    controller.setIndex(newIndex);
                    Navigator.of(context).pop(true);
                  },
                  text: 'Ok',
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}
