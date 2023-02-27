import 'package:flutter/cupertino.dart';
import 'package:lernapp/logic/nullable_extensions.dart';

import 'tab_destination.dart';

class CupertinoAdaptiveScaffold extends StatefulWidget {
  CupertinoAdaptiveScaffold({
    super.key,
    required this.showAppBar,
    required this.useSliverAppBar,
    this.actions,
    required this.primary,
    required this.destinations,
    this.title,
    this.body,
    this.previousTitle,
  }) : assert(
          (destinations != null && destinations.length >= 2) || body != null,
          'Either destinations has to provide a body or, body has to be supplied directly',
        );

  final Widget? body;
  final String? title;
  final String? previousTitle;
  final bool showAppBar;
  final bool useSliverAppBar;
  final List<Widget>? actions;
  final bool primary;
  final List<TabDestination>? destinations;

  @override
  State<CupertinoAdaptiveScaffold> createState() =>
      _CupertinoAdaptiveScaffoldState();
}

class _CupertinoAdaptiveScaffoldState extends State<CupertinoAdaptiveScaffold>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final CupertinoTabController tabController;

  bool get useBottomNavigation =>
      widget.destinations != null && widget.destinations!.isNotEmpty;

  @override
  void initState() {
    if (useBottomNavigation) {
      tabController = CupertinoTabController();
      pageController = PageController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSliverAppBar && widget.showAppBar) {
      if (useBottomNavigation) {
        return CupertinoTabScaffold(
          controller: tabController,
          tabBar: buildBottomNavigationBar()!,
          tabBuilder: buildSliverBody,
        );
      }
      return CupertinoPageScaffold(
        child: buildSliverBody(),
      );
    } else {
      if (useBottomNavigation) {
        return CupertinoTabScaffold(
          controller: tabController,
          tabBar: buildBottomNavigationBar()!,
          tabBuilder: buildNonSliverBody,
        );
      }
      return CupertinoPageScaffold(
        navigationBar: widget.showAppBar
            ? CupertinoNavigationBar(
                previousPageTitle: widget.previousTitle,
                middle: widget.title.map((t) => Text(t)),
                trailing: buildTrailing(),
              )
            : null,
        child: buildNonSliverBody(),
      );
    }
  }

  String? getCurrentTitle() {
    if (useBottomNavigation) {
      return widget.destinations![tabController.index].title;
    } else {
      return widget.title;
    }
  }

  CupertinoTabBar? buildBottomNavigationBar() {
    if (useBottomNavigation) {
      return CupertinoTabBar(
        currentIndex: tabController.index,
        items: widget.destinations!
            .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
            .toList(),
      );
    }
    return null;
  }

  Widget buildBody() {
    if (useBottomNavigation) {
      return widget.destinations![tabController.index].builder(context);
    } else {
      return widget.body!;
    }
  }

  Widget buildNonSliverBody([BuildContext? context, int? index]) {
    if (useBottomNavigation) {
      return CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: widget.previousTitle,
            middle: getCurrentTitle().map((t) => Text(t)),
            transitionBetweenRoutes: true,
            trailing: buildTrailing(),
          ),
          child: SafeArea(child: buildBody()),
        ),
      );
    } else {
      return buildBody();
    }
  }

  Widget buildSliverBody([BuildContext? context, int? index]) {
    return NestedScrollView(
      body: buildBody(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          CupertinoSliverNavigationBar(
            largeTitle: getCurrentTitle().map((e) => Text(e)),
            previousPageTitle: widget.previousTitle,
            trailing: buildTrailing(),
          )
        ];
      },
    );
  }

  Widget? buildTrailing() {
    return buildActions().map(
      (e) => Row(
        mainAxisSize: MainAxisSize.min,
        children: e,
      ),
    );
  }

  List<Widget>? buildActions() {
    if (useBottomNavigation) {
      return widget.destinations![tabController.index].actionsBuilder
          ?.call(context);
    } else {
      return widget.actions;
    }
  }
}
