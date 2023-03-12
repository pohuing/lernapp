import 'package:flutter/material.dart';

/// Optionally passes [child] in [wrapper] if [applyWrapper] is true
class OptionallyWrapped extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext context, Widget child) wrapper;
  final bool applyWrapper;

  const OptionallyWrapped({
    super.key,
    required this.child,
    required this.wrapper,
    required this.applyWrapper,
  });

  @override
  Widget build(BuildContext context) {
    return applyWrapper ? wrapper(context, child) : child;
  }
}
