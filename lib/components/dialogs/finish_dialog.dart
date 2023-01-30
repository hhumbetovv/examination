import 'package:examination/components/core/bordered_container.dart';
import 'package:examination/constants.dart';
import 'package:flutter/material.dart';

Future<bool?> finishDialog(BuildContext context, String text) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      //! Dialog Button
      ElevatedButton dialogButton({bool cancel = false}) {
        return ElevatedButton(
          onPressed: () {
            if (cancel) {
              Navigator.of(context).pop(false);
            } else {
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
          child: Text(cancel ? 'CANCEL' : 'OK'),
        );
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: Constants.radiusLarge),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: Theme.of(context).colorScheme.background,
        content: BorderedContainer(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: Constants.fontSizeMedium,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            children: [
              Expanded(child: dialogButton(cancel: true)),
              const SizedBox(width: 10),
              Expanded(child: dialogButton()),
            ],
          ),
        ],
      );
    },
  );
}
