import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Map<String, int>?> selectRangeDialog(
    BuildContext context, int rangeLength, Map<String, int> currentRange) async {
  return showDialog<Map<String, int>>(
    context: context,
    builder: ((context) {
      Map<String, int> newRange = currentRange;
      bool onChanged = false;

      SizedBox dialogInput({required bool firstValue}) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3.5,
          height: 55,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (value) {
              if (firstValue) {
                if (value.isNotEmpty && int.parse(value) < rangeLength - 1) {
                  newRange["firstValue"] = int.parse(value) - 1;
                }
                if (value.isEmpty) {
                  newRange["firstValue"] = 0;
                }
                if (value.isNotEmpty && int.parse(value) >= rangeLength - 1) {
                  newRange["firstValue"] = newRange["secondValue"]! - 1;
                }
              } else {
                if (value.isNotEmpty && int.parse(value) < rangeLength - 1) {
                  newRange["secondValue"] = int.parse(value) - 1;
                }
                if (value.isEmpty) {
                  newRange["secondValue"] = rangeLength;
                }
                if (value.isNotEmpty && int.parse(value) >= rangeLength - 1) {
                  newRange["secondValue"] = rangeLength - 1;
                }
              }
              onChanged = true;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: firstValue ? "1" : "$rangeLength",
              contentPadding: const EdgeInsets.only(
                bottom: 25,
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
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
              } else if (onChanged) {
                Navigator.of(context).pop(newRange);
              } else {
                Navigator.of(context).pop({"firstValue": 0, "secondValue": rangeLength - 1});
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
            dialogInput(firstValue: true),
            const Text(
              ' - ',
              style: TextStyle(fontSize: 30),
            ),
            dialogInput(firstValue: false),
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
