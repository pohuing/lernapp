import 'package:flutter/material.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/cupertino_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/material_adaptive_scaffold.dart';

import 'platform_adaptive_scaffold/tab_destination.dart';

/// A Scaffold that supports tabbed and not tabbed navigation with platform
/// specific looks
///
/// Supports iOS and Material styles
class PlatformAdaptiveScaffold extends StatelessWidget {
  /// Actions to show in the top right of the app bar
  /// If there is no app bar, or if [destinations] is not empty, this is ignored
  final Widget? trailing;

  /// Title to show, this is ignored if [destinations] is not empty
  final String? title;
  final String? previousTitle;

  /// The contents of the scaffold, this is ignored if [destinations] is not empty
  final Widget? body;
  final bool primary;

  /// Use a platform specific app bar that collapses when the content is scrolled
  final bool useSliverAppBar;
  final bool allowBackGesture;
  final bool showAppBar;

  /// Destinations from which to build the bottom navigation bar, the navigation
  /// bar as well as the current page's body
  ///
  /// This has to have at least two destinations
  final List<TabDestination>? destinations;

  const PlatformAdaptiveScaffold({
    super.key,
    this.trailing,
    this.title,
    this.previousTitle,
    this.body,
    bool? primary,
    bool? useSliverAppBar,
    bool? allowBackGesture,
    bool? showAppBar,
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
        destinations: destinations,
        title: title,
        body: body,
        previousTitle: previousTitle,
        trailing: trailing,
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
        trailing: trailing,
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
