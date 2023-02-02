import 'package:examination/utils/constants.dart';
import 'package:examination/utils/theme.dart';
import 'package:flutter/material.dart';

import '../bordered_container.dart';
import '../dialog_button.dart';

Future<bool?> selectThemeDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      final List<AppColors> appColors = AppColors.colors;

      Expanded color(int index) {
        return Expanded(
          child: InkWell(
            onTap: () {},
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: Constants.radiusSmall,
                  border: Border.all(
                    color: appColors[index].primaryLight,
                  ),
                  color: appColors[index].primaryDark,
                ),
              ),
            ),
          ),
        );
      }

      //! Dialog
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: BorderedContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  color(0),
                  const SizedBox(width: 10),
                  color(1),
                  const SizedBox(width: 10),
                  color(2),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  color(3),
                  const SizedBox(width: 10),
                  color(4),
                  const SizedBox(width: 10),
                  color(5),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  color(6),
                  const SizedBox(width: 10),
                  color(7),
                  const SizedBox(width: 10),
                  color(8),
                ],
              ),
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
                      Navigator.of(context).pop(true);
                    },
                    text: 'Ok'),
              ),
            ],
          ),
        ],
      );
    }),
  );
}
