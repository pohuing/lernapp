import 'package:flutter/material.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/cupertino_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/material_adaptive_scaffold.dart';

import 'platform_adaptive_scaffold/tab_destination.dart';

class PlatformAdaptiveScaffold extends StatelessWidget {
  final List<Widget>? actions;
  final String? title;
  final String? previousTitle;
  final Widget? body;
  final bool primary;
  final bool useSliverAppBar;
  final bool allowBackGesture;
  final bool showAppBar;
  final ScrollController? scrollController;
  final List<TabDestination>? destinations;

  PlatformAdaptiveScaffold({
    super.key,
    this.actions,
    this.title,
    this.previousTitle,
    this.body,
    bool? primary,
    bool? useSliverAppBar,
    bool? allowBackGesture,
    bool? showAppBar,
    this.scrollController,
    this.destinations,
  })  : primary = primary ?? true,
        useSliverAppBar = useSliverAppBar ?? true,
        allowBackGesture = allowBackGesture ?? true,
        showAppBar = showAppBar ?? true,
        assert(
          (destinations != null && destinations.length >= 2) || body != null,
          'Either destinations has to provide a body or, body has to be supplied directly',
        );

  @override
  Widget build(BuildContext context) {
    Widget value;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      value = CupertinoAdaptiveScaffold(
        showAppBar: showAppBar,
        useSliverAppBar: useSliverAppBar,
        primary: primary,
        destinations: destinations,
        title: title,
        body: body,
        previousTitle: previousTitle,
      );
      value = Material(
        color: Colors.transparent,
        child: value,
      );
    } else {
      value = MaterialAdaptiveScaffold(
        showAppBar: showAppBar,
        useSliverAppBar: useSliverAppBar,
        primary: primary,
        destinations: destinations,
        body: body,
        title: title,
      );
    }

    if (!showAppBar) {
      value = SafeArea(child: value);
    }

    return WillPopScope(
      onWillPop: allowBackGesture
          ? null
          : () => Future.value(!Navigator.of(context).userGestureInProgress),
      child: value,
    );
  }
}
