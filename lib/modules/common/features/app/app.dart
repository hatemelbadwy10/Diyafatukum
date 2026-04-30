import 'package:bot_toast/bot_toast.dart';
import 'package:deals/modules/common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/flavor/flavor_config.dart';
import '../../../../core/config/router/route_manager.dart';
import '../../../../core/config/service_locator/injection.dart';
import '../../../../core/config/theme/light_theme.dart';
import 'custom_responsive_breakpoints.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(sl(),sl()),
      child: MaterialApp.router(
        locale: context.locale,
        title: FlavorConfig.displayName,
        routerConfig: BaseRouter.routerConfig,
        builder: (context, child) {
          final botToastBuilder = BotToastInit();
          child = botToastBuilder(context, child);
          return CustomResponsiveBreakpoints(child: child);
        },
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: LightTheme.getTheme(),
      ),
    );
  }
}
