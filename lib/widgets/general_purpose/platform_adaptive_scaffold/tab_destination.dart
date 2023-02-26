import 'package:flutter/widgets.dart';

class TabDestination {
  final Widget Function() builder;
  final String title;
  final Icon icon;

  TabDestination(this.builder, this.title, this.icon);
}
