import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/resources/resources.dart';

enum AddressType {
  home,
  work,
  apartment;

  static AddressType fromValue(String value) {
    return AddressType.values.firstWhere((e) => e.name == value, orElse: () => AddressType.apartment);
  }

  String get title {
    switch (this) {
      case AddressType.home:
        return LocaleKeys.addresses_details_type_home.tr();
      case AddressType.work:
        return LocaleKeys.addresses_details_type_work.tr();
      case AddressType.apartment:
        return LocaleKeys.addresses_details_type_apartment.tr();
    }
  }

  SvgGenImage get icon {
    switch (this) {
      case AddressType.home:
        return Assets.icons.solarHome2Broken;
      case AddressType.work:
        return Assets.icons.stashArrowUpDuotone;
      case AddressType.apartment:
        return Assets.icons.mdiBellNotificationOutline;
    }
  }
}
