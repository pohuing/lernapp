import 'package:flutter/widgets.dart';

class TabDestination {
  final Widget Function(BuildContext context) builder;
  final String title;
  final Icon icon;
  final Widget? Function(BuildContext context)? trailingBuilder;

  const TabDestination({
    required this.builder,
    required this.title,
    required this.icon,
    this.trailingBuilder,
  });
}
