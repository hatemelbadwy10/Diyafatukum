import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../datasource/settings_remote_datasource.dart';
import '../model/faq_model.dart';
import '../model/social_media_platform_enum.dart';
import '../model/static_page_enum.dart';

abstract class SettingsRepository {
  Result contactUs(BodyMap body);
  Result<String> getStaticPageContent(StaticPage type);
  Result<Map<SocialMediaPlatform, String>> getContacts();
  Result changeLanguage(BodyMap body);
  Result<List<FaqModel>> getFaqs(ParamsMap params);
}

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  const SettingsRepositoryImpl(this.remoteDataSource);

  @override
  Result<String> getStaticPageContent(StaticPage type) async {
    return remoteDataSource.getStaticPageContent(type).toResult((json) => json['content']);
  }

  @override
  Result contactUs(BodyMap body) async {
    return remoteDataSource.contactUs(body).toResult(noDataFromJson);
  }

  @override
  Result<Map<SocialMediaPlatform, String>> getContacts() async {
    return remoteDataSource.getContacts().toResult((json) => SocialMediaPlatform.fromJson(json));
  }

  @override
  Result changeLanguage(BodyMap body) async {
    return remoteDataSource.changeLanguage(body).toResult(noDataFromJson);
  }

  @override
  Result<List<FaqModel>> getFaqs(ParamsMap params) async {
    return remoteDataSource.getFaqs(params).toResult(faqsModelFromJson);
  }
}
