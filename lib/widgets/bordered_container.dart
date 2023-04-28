import 'package:flutter/material.dart';

import '../utils/constants.dart';

class BorderedContainer extends StatelessWidget {
  const BorderedContainer({
    Key? key,
    required this.child,
    this.alignment,
    this.color,
    this.constraints,
  }) : super(key: key);

  final Widget child;
  final AlignmentGeometry? alignment;
  final Color? color;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(10),
      constraints: constraints,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: Constants.radiusMedium,
      ),
      child: child,
    );
  }
}
