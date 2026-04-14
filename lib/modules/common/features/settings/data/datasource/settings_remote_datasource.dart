import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../model/static_page_enum.dart';

abstract class SettingsRemoteDataSource {
  Future<Response> getStaticPageContent(StaticPage type);
  Future<Response> contactUs(BodyMap body);
  Future<Response> getContacts();
  Future<Response> getFaqs(ParamsMap params);
  Future<Response> changeLanguage(BodyMap body);
}

@LazySingleton(as: SettingsRemoteDataSource)
class AccountRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient client;
  const AccountRemoteDataSourceImpl(this.client);

  @override
  Future<Response> getStaticPageContent(StaticPage type) async => client.get(type.endpoint);

  @override
  Future<Response> contactUs(BodyMap body) async => client.post(RemoteUrls.contact, data: body);

  @override
  Future<Response> getContacts() async => client.get(RemoteUrls.contacts);

  @override
  Future<Response> getFaqs(ParamsMap params) async => client.get(RemoteUrls.faq, queryParameters: params);

  @override
  Future<Response> changeLanguage(BodyMap body) async => client.post(RemoteUrls.language, data: body);
}
