import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/question_controller.dart';

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
      SizedBox dialogButton({bool cancel = false}) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (cancel) Navigator.of(context).pop();
              controller.setIndex(newIndex);
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: cancel ? Colors.red : Colors.green),
            child: Text(cancel ? 'CANCEL' : 'OK'),
          ),
        );
      }

      //! Dialog
      return AlertDialog(
        content: Row(
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
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          dialogButton(cancel: true),
          dialogButton(),
        ],
      );
    }),
  );
}
