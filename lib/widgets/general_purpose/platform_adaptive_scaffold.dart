import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lernapp/logic/nullable_extensions.dart';

class PlatformAdaptiveScaffold extends StatelessWidget {
  final List<Widget>? actions;
  final String title;
  final String? previousTitle;
  final Widget body;
  final bool primary;
  final bool useSliverAppBar;
  final bool allowBackGesture;
  final bool showAppBar;

  const PlatformAdaptiveScaffold({
    super.key,
    this.actions,
    required this.title,
    this.previousTitle,
    required this.body,
    bool? primary,
    bool? useSliverAppBar,
    bool? allowBackGesture,
    bool? showAppBar,
  })  : primary = primary ?? true,
        useSliverAppBar = useSliverAppBar ?? true,
        allowBackGesture = allowBackGesture ?? true,
        showAppBar = showAppBar ?? true;

  @override
  Widget build(BuildContext context) {
    Widget value;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      if (useSliverAppBar && showAppBar) {
        value = CupertinoPageScaffold(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(title),
                  previousPageTitle: previousTitle,
                  trailing: actions.map(
                    (value) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: value,
                    ),
                  ),
                )
              ];
            },
            body: body,
          ),
        );
      } else {
        value = CupertinoPageScaffold(
          navigationBar: showAppBar
              ? CupertinoNavigationBar(
                  previousPageTitle: previousTitle,
                  middle: Text(title),
                  trailing: actions.map(
                    (e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: e,
                    ),
                  ),
                )
              : null,
          child: body,
        );
      }
      value = Material(
        color: Colors.transparent,
        child: value,
      );
    } else {
      if (useSliverAppBar && showAppBar) {
        value = Scaffold(
          primary: primary,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar.large(
                  title: Text(title),
                  actions: actions,
                ),
              ];
            },
            body: body,
          ),
        );
      } else {
        value = Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: actions,
          ),
          primary: primary,
          body: body,
        );
      }
    }

    if (!showAppBar) {
      value = SafeArea(child: value);
    }

    return WillPopScope(
      onWillPop: allowBackGesture
          ? null
          : () => Future.value(Navigator.of(context).userGestureInProgress),
      child: value,
    );
  }
}
