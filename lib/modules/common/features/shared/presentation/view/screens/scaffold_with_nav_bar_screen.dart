import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/navigation_bar_items.dart';
import '../widgets/login_dialog.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class ScaffoldWithNavBarScreen extends StatefulWidget {
  const ScaffoldWithNavBarScreen({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<ScaffoldWithNavBarScreen> createState() =>
      _ScaffoldWithNavBarScreenState();
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
      bottomNavigationBar: CustomBottomNavigationBar(onTap: _onTap),
    );
  }

  void _onTap(NavigationBarItems item) {
    final isGuest = context.read<AuthCubit>().state.status.isGuest;
    final isProtectedItem =
        item == NavigationBarItems.stores ||
        item == NavigationBarItems.auctions;
    if (isGuest && isProtectedItem) {
      LoginDialog().show(context);
      return;
    }
    item.navigate();
  }
}
