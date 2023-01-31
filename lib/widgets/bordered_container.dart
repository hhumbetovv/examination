import 'package:flutter/material.dart';

import '../constants.dart';

class BorderedContainer extends StatelessWidget {
  const BorderedContainer({
    Key? key,
    required this.child,
    this.alignment,
  }) : super(key: key);

  final Widget child;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: Constants.radiusMedium,
      ),
      child: child,
    );
  }
}
