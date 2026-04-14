import 'package:flutter/material.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../core/config/router/route_manager.dart';

abstract class BaseMenuItem {
  String get title;
  SvgGenImage? get icon;
  AssetGenImage? get image;
  BaseRoute? get route;
  bool get isDestructive => false;
  Object? get arguments;
  Color? get iconColor => null;
  Color? get iconBackgroundColor => null;
  bool get needAuthorization => false;
}
