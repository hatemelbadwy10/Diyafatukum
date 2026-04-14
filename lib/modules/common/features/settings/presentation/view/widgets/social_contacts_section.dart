import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/shimmer_widget.dart';
import '../../controller/contacts_cubit/contacts_cubit.dart';

class SocialContactsSection extends StatelessWidget {
  const SocialContactsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactsCubit>(),
      child: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          return state.status.build(
            onFailed: () => SizedBox.shrink(),
            onLoading: () => SizedBox.shrink(),
            onSuccess: (value) {
              return Column(
                spacing: 8,
                children: [
                  Text(LocaleKeys.details_contact_follow.tr(), style: context.bodyMedium.s12),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: state.status.data?.entries.map((entry) {
                          final platform = entry.key;
                          final value = entry.value;
                          if (state.status.isSuccess) {
                            return platform.icon
                                .svg(height: 18)
                                .paddingAll(8)
                                .onTap(() => platform.launch(value), borderRadius: 100.borderRadius)
                                .setContainerToView(
                                  color: platform.iconColor,
                                  radius: 100,
                                  gradient: platform.iconGradient,
                                );
                          } else {
                            return ShimmerWidget.circular(radius: 20);
                          }
                        }).toList() ??
                        [],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
