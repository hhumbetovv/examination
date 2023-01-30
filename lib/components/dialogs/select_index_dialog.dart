import 'package:examination/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/question_controller.dart';
import '../core/bordered_container.dart';

Future<bool?> selectIndexDialog(BuildContext context, QuestionController controller) async {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      int newIndex = controller.currentIndex;

      //! Dialog Input
      TextField dialogInput() {
        return TextField(
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
            hintText: '${controller.currentIndex + 1}',
          ),
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 30),
        );
      }

      //! Dialog Button
      ElevatedButton dialogButton({bool cancel = false, String? text}) {
        return ElevatedButton(
          onPressed: () {
            if (cancel) {
              Navigator.of(context).pop();
            } else {
              controller.setIndex(newIndex);
              Navigator.of(context).pop(true);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: cancel ? Colors.red : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: Constants.radiusMedium,
            ),
          ),
          child: Text(text ?? ''),
        );
      }

      //! Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: Constants.radiusLarge),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: Theme.of(context).colorScheme.background,
        content: BorderedContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: dialogInput(),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  ' / ${controller.currentSettings.count}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(child: dialogButton(cancel: true, text: 'CANCEL')),
              const SizedBox(width: 10),
              Expanded(child: dialogButton(text: 'OK')),
            ],
          ),
        ],
      );
    }),
  );
}
