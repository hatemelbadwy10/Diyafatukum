import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../controller/user_home_cubit/user_home_cubit.dart';
import '../widgets/user_home_body.dart';
import '../widgets/user_home_skeleton.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserHomeCubit>()..getHomeData(),
      child: BlocBuilder<UserHomeCubit, UserHomeState>(
        builder: (context, state) {
          final cubit = context.read<UserHomeCubit>();
          final cachedData = state.status.data;
          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            body: SafeArea(
              child: state.status.build(
                onLoading: () => cachedData != null
                    ? UserHomeBody(
                        data: cachedData,
                        searchQuery: state.searchQuery,
                        onSearchChanged: cubit.onSearchChanged,
                      )
                    : const UserHomeSkeleton(),
                onRetry: () => cubit.getHomeData(),
                onSuccess: (data) => UserHomeBody(
                  data: data,
                  searchQuery: state.searchQuery,
                  onSearchChanged: cubit.onSearchChanged,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
