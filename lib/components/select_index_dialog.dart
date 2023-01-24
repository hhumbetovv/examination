import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<int?> selectIndexDialog(BuildContext context, int index, int length) async {
  return showDialog<int>(
    context: context,
    builder: ((context) {
      int newIndex = index;
      TextField dialogInput({required bool firstValue}) {
        return TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              newIndex = int.parse(value) - 1;
            } else {
              newIndex = index;
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '${index + 1}',
          ),
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 30),
        );
      }

      SizedBox dialogButton({bool cancel = false}) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (cancel) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop(newIndex);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: cancel ? Colors.red : Colors.green),
            child: Text(cancel ? 'CANCEL' : 'OK'),
          ),
        );
      }

      return AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 100, child: dialogInput(firstValue: true)),
            Expanded(
              flex: 120,
              child: Text(
                ' / $length',
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
