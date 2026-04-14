import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_dialog.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/address_model.dart';
import '../../controller/addresses_cubit/addresses_cubit.dart';
import '../../controller/delete_address_cubit/delete_address_cubit.dart';
import '../screens/address_details_screen.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
    this.trailing,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.readOnly = false,
  });
  final AddressModel? address;
  final Widget? trailing;
  final Function()? onTap;
  final double? padding;
  final Color? backgroundColor;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (address?.type.icon ?? Assets.icons.ionLocationSharp1)
            .svg(width: AppSize.iconNormal, colorFilter: context.primaryColor.colorFilter)
            .setContainerToView(padding: 8, color: context.primaryContainerColor, radius: 100),
        12.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address?.type.title ?? LocaleKeys.bag_checkout_address_required_title.tr(),
              style: context.bodyLarge.regular.s12,
            ),
            2.gap,
            Text(
              address?.fullAddress ?? LocaleKeys.bag_checkout_address_required_message.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.displayLarge.regular.s14,
            ).paddingEnd(16),
          ],
        ).expand(),
        if (trailing != null) ...[
          trailing!,
        ] else if (!readOnly && address != null) ...[
          CustomIconButton.svg(
            size: 14,
            borderRadius: 100,
            padding: 6.edgeInsetsAll,
            svg: Assets.icons.tablerEdit,
            onPressed: () => _onAddressTap(context),
            backgroundColor: context.primaryContainerColor,
          ),
          8.gap,
          CustomIconButton.svg(
            svg: Assets.icons.deleteIcon,
            padding: 6.edgeInsetsAll,
            borderRadius: 100,
            size: 14,
            backgroundColor: context.errorSwatch.shade100,
            foregroundColor: context.errorColor,
            onPressed: () => context.showDialog(
              BlocProvider(
                create: (context) => sl<DeleteAddressCubit>(),
                child: BlocConsumer<DeleteAddressCubit, DeleteAddressState>(
                  listener: (ctx, state) => state.status.listen(
                    onFailed: (error) => Toaster.showToast(error.message),
                    onSuccess: (data) {
                      BaseRouter.pop();
                      context.read<AddressesCubit>().deleteAddress(address!.id);
                      Toaster.showToast(state.status.message, isError: false);
                      if (address!.isDefault) {
                        context.read<AuthCubit>().deleteUserAddress();
                      }
                    },
                  ),
                  builder: (context, state) {
                    return CustomDialog.destructive(
                      isLoading: state.status.isLoading,
                      title: LocaleKeys.addresses_delete_title.tr(),
                      subtitle: LocaleKeys.addresses_delete_message.tr(),
                      confirmLabel: LocaleKeys.actions_delete.tr(),
                      onConfirm: () => context.read<DeleteAddressCubit>().deleteAddress(address!.id.toString()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    )
        .paddingSymmetric(padding ?? 8, 16)
        .onTap(readOnly ? null : () => _onAddressTap(context), borderRadius: AppSize.mainRadius.borderRadius)
        .setContainerToView(radius: AppSize.mainRadius, color: backgroundColor ?? context.surfaceColor);
  }

  void _onAddressTap(BuildContext context) {
    if (onTap != null) {
      onTap?.call();
      return;
    }
    AppRoutes.addressDetails.push(
      extra: AddressDetailsScreenArguments(
        address: address,
        onAddressUpdated: (AddressModel updatedAddress) {
          context.read<AddressesCubit>().updateAddress(updatedAddress);
        },
      ),
    );
  }
}
