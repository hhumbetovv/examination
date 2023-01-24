import 'package:examination/components/custom_elevated_button.dart';
import 'package:flutter/material.dart';

Future<String?> selectSettingDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: ((context) {
      List<Map<String, String>> selections = [
        {'text': 'All Questions', 'key': 'all'},
        {'text': 'Long Answers', 'key': 'longs'},
        {'text': 'Short Answers', 'key': 'shorts'},
        {'text': 'Cancel', 'key': 'cancel'},
      ];
      return AlertDialog(
        actionsOverflowButtonSpacing: 10,
        actions: selections.map((item) {
          return CustomElevatedButton(
              text: item['text']!,
              onPressed: () {
                Navigator.of(context).pop(item['key']);
              });
        }).toList(),
      );
    }),
  );
}
