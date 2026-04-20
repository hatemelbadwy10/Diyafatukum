import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_arrow_back.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../controller/provider_home_cubit/provider_home_cubit.dart';
import '../widgets/provider_home_order_card.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProviderHomeCubit, ProviderHomeState>(
          builder: (context, state) {
            final cubit = context.read<ProviderHomeCubit>();

            return state.status.build(
              onLoading: () => const CustomLoading(),
              onFailed: () => CustomFallbackView(
                title: LocaleKeys.error_ops.tr(),
                subtitle: state.status.message,
                buttonLabel: LocaleKeys.actions_retry.tr(),
                onButtonPressed: cubit.loadHome,
              ),
              onSuccess: (_) => Column(
                children: [
                  _ProviderHomeHeader(
                    providerName: state.home?.providerName ?? '',
                  ),
                  28.gap,
                  _ProviderHomeDayHeader(),
                  20.gap,
                  VerticalListView(
                    itemCount: state.orders.length,
                    padding: AppSize.screenPadding.edgeInsetsHorizontal,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return ProviderHomeOrderCard(
                        order: order,
                        onAccept: () => cubit.acceptOrder(order.id),
                        onReject: () => cubit.rejectOrder(order.id),
                      );
                    },
                  ).expand(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProviderHomeHeader extends StatelessWidget {
  const _ProviderHomeHeader({required this.providerName});

  final String providerName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.icons.solarUserBold
            .svg(
              width: 28,
              height: 28,
              colorFilter: context.scaffoldBackgroundColor.colorFilter,
            )
            .setContainerToView(
              color: context.primaryColor,
              radius: 18,
              padding: 18,
            ),
        16.gap,

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.provider_home_greeting.tr(),
              style: context.titleMedium.medium,
            ),
            8.gap,
            Text(providerName, style: context.titleMedium.regular),
          ],
        ),

        Spacer(),
        Stack(
          children: [
            Assets.icons.cuidaNotificationBellOutline
                .svg(
                  width: 28,
                  height: 28,
                  colorFilter: context.primaryColor.colorFilter,
                )
                .setContainerToView(
                  color: context.primarySwatch.shade50,
                  radius: 22,
                  padding: 18,
                ),
            PositionedDirectional(
              top: 10,
              end: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: context.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    ).paddingHorizontal(AppSize.screenPadding).paddingTop(20);
  }
}

class _ProviderHomeDayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomArrowBack(),
        const Spacer(),
        Text(
          LocaleKeys.details_date_time_today.tr(),
          style: context.displaySmall.medium.s22,
        ),
        const Spacer(),
        Transform.flip(flipX: true, child: const CustomArrowBack()),
      ],
    ).paddingHorizontal(AppSize.screenPadding);
  }
}
