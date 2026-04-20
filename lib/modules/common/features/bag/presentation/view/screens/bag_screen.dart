import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../controller/bag_cubit/bag_cubit.dart';
import '../widgets/bag_item_card.dart';
import '../widgets/bag_summary_section.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  @override
  void initState() {
    super.initState();
    bottomNavNotifier.addListener(_handleNavigationChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BagCubit>().loadBag();
      }
    });
  }

  @override
  void dispose() {
    bottomNavNotifier.removeListener(_handleNavigationChange);
    super.dispose();
  }

  void _handleNavigationChange() {
    if (!mounted || bottomNavNotifier.value != NavigationBarItems.stores) {
      return;
    }
    context.read<BagCubit>().loadBag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: LocaleKeys.bag_title.tr(),
        titleStyle: context.displaySmall.bold.s18,
        backgroundColor: context.scaffoldBackgroundColor,
       
      ),
      body: BlocBuilder<BagCubit, BagState>(
        builder: (context, state) {
          final cubit = context.read<BagCubit>();

          return state.status.build(
            onLoading: () => const CustomLoading(),
            onSuccess: (_) => Column(
              children: [
                VerticalListView(
                  itemCount: state.isEmpty ? 1 : state.bag.items.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.screenPadding,
                    vertical: 20,
                  ),
                  separator: 16.gap,
                  itemBuilder: (context, index) {
                    if (state.isEmpty) {
                      return SizedBox(
                        height: context.height * 0.45,
                        child: CustomFallbackView(
                          icon: Assets.icons.solarCartCheckBroken.svg(
                            width: 72,
                            height: 72,
                            colorFilter: context.primaryColor.colorFilter,
                          ),
                          title: LocaleKeys.bag_empty_title.tr(),
                          subtitle: LocaleKeys.bag_empty_subtitle.tr(),
                          buttonLabel: LocaleKeys.bag_empty_action.tr(),
                          onButtonPressed: () {
                            bottomNavNotifier.value = NavigationBarItems.home;
                            AppRoutes.home.go();
                          },
                        ),
                      );
                    }

                    final item = state.bag.items[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.screenPadding + 24,
                        ),
                        decoration: BoxDecoration(
                          color: context.errorColor,
                          borderRadius: 24.borderRadius,
                        ),
                        child: Assets.icons.trash.svg(
                          width: 34,
                          height: 34,
                          colorFilter: Colors.white.colorFilter,
                        ),
                      ),
                      onDismissed: (_) => cubit.removeItem(item.id),
                      child: BagItemCard(item: item),
                    );
                  },
                ).expand(),
                if (!state.isEmpty) BagSummarySection(bag: state.bag).bottomSafeArea(),
              ],
            ),
          );
        },
      ),
    );
  }
}
