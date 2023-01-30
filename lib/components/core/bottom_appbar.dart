import 'package:examination/constants.dart';
import 'package:flutter/material.dart';

class BottomAppBarCore extends StatelessWidget {
  const BottomAppBarCore({
    Key? key,
    this.child,
    this.shape,
    this.color,
    this.notchMargin,
  }) : super(key: key);

  final Widget? child;
  final NotchedShape? shape;
  final Color? color;
  final double? notchMargin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.appBarHeight,
      child: BottomAppBar(
        shape: shape ?? const CircularNotchedRectangle(),
        color: color ?? Theme.of(context).colorScheme.primary,
        notchMargin: notchMargin ?? 8,
        child: child,
      ),
    );
  }
}
