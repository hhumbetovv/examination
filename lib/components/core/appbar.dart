import 'package:examination/constants.dart';
import 'package:flutter/material.dart';

class AppBarCore extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  AppBarCore({
    Key? key,
    this.backgroundColor,
    this.centerTitle = true,
    this.title,
    this.titleText,
    this.shape,
    this.actions,
  })  : preferredSize = const Size.fromHeight(Constants.appBarHeight),
        super(key: key);

  final Color? backgroundColor;
  final bool? centerTitle;
  final Widget? title;
  final String? titleText;
  final ShapeBorder? shape;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      title: title ??
          Text(
            titleText ?? '',
            style: TextStyle(
              fontSize: Constants.fontSizeSmall,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
      centerTitle: centerTitle,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      actions: actions,
      iconTheme: const IconThemeData(
          // shadows: [Shadow(color: Theme.of(context).colorScheme.secondary, blurRadius: 30.0)],
          ),
    );
  }
}
