
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/bloc_observer/app_bloc_observer.dart';
import 'core/config/flavor/flavor_config.dart';
import 'core/config/flavor/flavor_type_enum.dart';
import 'core/config/router/route_manager.dart';
import 'core/config/service_locator/injection.dart';
import 'core/utils/notifications.dart';
import 'core/utils/platform_channels_utils.dart';
import 'modules/common/features/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Driver flavor
  FlavorConfig.initialize(FlavorType.provider);

  await FlavorConfig.initializeFirebase();

  await RemoteNotificationServices.initialize();

  await dotenv.load(fileName: ".env");

  // Set Google Maps API key via platform channels
  await PlatformChannelsUtils.setGoogleMapsApiKey();

  Bloc.observer = AppBlocObserver();

  RouteManager.configureRoutes();
  Future.wait([EasyLocalization.ensureInitialized(), configureInjection()]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}
