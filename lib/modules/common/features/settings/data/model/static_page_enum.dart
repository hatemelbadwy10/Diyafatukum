import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

import '../../../../../../../core/resources/resources.dart';

enum StaticPage {
  about,
  terms,
  privacy,
  cancellationRefund;

  String get title {
    switch (this) {
      case StaticPage.about:
        return LocaleKeys.settings_about.tr();
      case StaticPage.terms:
        return LocaleKeys.settings_terms.tr();
      case StaticPage.privacy:
        return LocaleKeys.settings_privacy.tr();
      case StaticPage.cancellationRefund:
        return LocaleKeys.settings_refund_policy.tr();
    }
  }

  String get endpoint {
    switch (this) {
      case StaticPage.about:
        return RemoteUrls.about;
      case StaticPage.terms:
        return RemoteUrls.terms;
      case StaticPage.privacy:
        return RemoteUrls.privacy;
      case StaticPage.cancellationRefund:
        return RemoteUrls.cancellationRefund;
    }
  }
}
