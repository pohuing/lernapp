import 'package:flutter/material.dart';
import 'package:lernapp/logic/nullable_extensions.dart';

import 'tab_destination.dart';

class MaterialAdaptiveScaffold extends StatefulWidget {
  MaterialAdaptiveScaffold({
    super.key,
    required this.showAppBar,
    required this.useSliverAppBar,
    this.actions,
    required this.primary,
    required this.destinations,
    this.title,
    this.body,
  }) : assert(
          (destinations != null && destinations.length >= 2) || body != null,
          'Either destinations has to provide a body or, body has to be supplied directly',
        );

  final Widget? body;
  final String? title;
  final bool showAppBar;
  final bool useSliverAppBar;
  final List<Widget>? actions;
  final bool primary;
  final List<TabDestination>? destinations;

  @override
  State<MaterialAdaptiveScaffold> createState() =>
      _MaterialAdaptiveScaffoldState();
}

class _MaterialAdaptiveScaffoldState extends State<MaterialAdaptiveScaffold>
    with TickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;

  bool get useBottomNavigation =>
      widget.destinations != null && widget.destinations!.isNotEmpty;

  @override
  void initState() {
    if (useBottomNavigation) {
      tabController =
          TabController(length: widget.destinations!.length, vsync: this);
      pageController = PageController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSliverAppBar && widget.showAppBar) {
      return Scaffold(
        primary: widget.primary,
        bottomNavigationBar: buildBottomNavigationBar(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.large(
                title: getCurrentTitle().map((t) => Text(t)),
                actions: buildActions(),
              ),
            ];
          },
          body: buildCurrentBody(),
        ),
      );
    } else {
      return Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                title: getCurrentTitle().map((t) => Text(t)),
                actions: buildActions(),
              )
            : null,
        bottomNavigationBar: buildBottomNavigationBar(),
        primary: widget.primary,
        body: buildCurrentBody(),
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

  NavigationBar? buildBottomNavigationBar() {
    if (useBottomNavigation) {
      return NavigationBar(
        selectedIndex: tabController.index,
        onDestinationSelected: (i) => setState(() {
          tabController.index = i;
          pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutSine,
          );
        }),
        destinations: [
          ...widget.destinations!
              .map((e) => NavigationDestination(icon: e.icon, label: e.title))
        ],
      );
    }
    return null;
  }

  Widget buildCurrentBody() {
    if (useBottomNavigation) {
      return PageView(
        onPageChanged: (value) => setState(() => tabController.index = value),
        controller: pageController,
        children: widget.destinations!.map((e) => e.builder(context)).toList(),
      );
    } else {
      return widget.body!;
    }
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
