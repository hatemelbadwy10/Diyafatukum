import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/navigation_bar_items.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class ScaffoldWithNavBarScreen extends StatefulWidget {
  const ScaffoldWithNavBarScreen({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<ScaffoldWithNavBarScreen> createState() => _ScaffoldWithNavBarScreenState();
}

class _ScaffoldWithNavBarScreenState extends State<ScaffoldWithNavBarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.shell,
      bottomNavigationBar: CustomBottomNavigationBar(onTap: (index) => _onTap(index)),
    );
  }

  void _onTap(int index) {
    bottomNavNotifier.value = NavigationBarItems.values[index];
    widget.shell.goBranch(index);
  }
}
