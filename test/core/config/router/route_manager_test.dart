import 'package:flutter_test/flutter_test.dart';

import 'package:diyafatukum/core/config/flavor/flavor_config.dart';
import 'package:diyafatukum/core/config/flavor/flavor_type_enum.dart';
import 'package:diyafatukum/core/config/router/app_route.dart';
import 'package:diyafatukum/core/config/router/route_manager.dart';

void main() {
  test('user routes include address details', () {
    FlavorConfig.initialize(FlavorType.user);

    RouteManager.configureRoutes();

    expect(
      BaseRouter.routerConfig.namedLocation(AppRoutes.addressDetails.name),
      AppRoutes.addressDetails.path,
    );
  });
}
