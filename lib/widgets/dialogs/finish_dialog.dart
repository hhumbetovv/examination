import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../bordered_container.dart';
import '../dialog_button.dart';

Future<bool?> finishDialog(BuildContext context, String text) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      //! Dialog
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: BorderedContainer(
          constraints: const BoxConstraints(
            maxWidth: 480,
          ),
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
              const Expanded(child: DialogButton()),
              const SizedBox(width: 10),
              Expanded(
                child: DialogButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  text: 'Ok',
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
