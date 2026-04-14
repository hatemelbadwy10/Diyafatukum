import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/address_model.dart';
import '../../controller/addresses_cubit/addresses_cubit.dart';
import '../../controller/default_address_cubit/default_address_cubit.dart';

class AddressSelectionIndicator extends StatelessWidget {
  const AddressSelectionIndicator({super.key, required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DefaultAddressCubit, DefaultAddressState>(
      listener: (context, state) {
        state.status.listen(
          onFailed: (error) => Toaster.showToast(error.message),
          onSuccess: (_) {
            context.read<AddressesCubit>().setDefaultAddress(state.address.id);
            context.read<AuthCubit>().updateUserAddress(state.address);
            Toaster.showToast(LocaleKeys.addresses_success_default.tr(), isError: false);
          },
        );
      },
      builder: (context, state) {
        if (state.status.isLoading && state.address.id == address.id) {
          return CustomLoading().center();
        } else if (address.isDefault) {
          return Assets.icons.icon.svg(height: 16).setContainerToView(color: context.secondaryColor, radius: 100);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
