import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/infinite_scroll_pagination/paginated_grid_view.dart';
import '../../../../home/data/model/user_home_model.dart';
import '../../controller/single_service_cubit/single_service_cubit.dart';
import '../../../data/model/single_service_model.dart';
import '../../../data/model/single_service_store_model.dart';
import '../widgets/single_service_product_card.dart';

class SingleServiceScreen extends StatelessWidget {
  const SingleServiceScreen({
    super.key,
    required this.service,
  });

  final UserHomeServiceModel service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SingleServiceCubit>()..initialize(service),
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        appBar: CustomAppBar.build(
          removeBack: false,
          titleText: service.name,
          backgroundColor: context.scaffoldBackgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocBuilder<SingleServiceCubit, SingleServiceState>(
          builder: (context, state) {
            final cubit = context.read<SingleServiceCubit>();
            return PaginatedGridView<int, SingleServiceProductModel>(
              controller: cubit.pagingController,
              padding: EdgeInsets.fromLTRB(
                AppSize.screenPadding,
                20,
                AppSize.screenPadding,
                24,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 160/250,
              onRetry: () => cubit.pagingController.refresh(),
              itemBuilder: (context, item, index) {
                return SingleServiceProductCard(
                  product: item,
                  onTap: () => AppRoutes.singleServiceStore.push(
                    extra: SingleServiceStoreScreenArguments(
                      service: service,
                      store: item,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
