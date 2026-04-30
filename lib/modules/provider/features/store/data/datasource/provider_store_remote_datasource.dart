import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

abstract class ProviderStoreRemoteDataSource {
  Future<Response> getStore();
}

@LazySingleton(as: ProviderStoreRemoteDataSource)
class ProviderStoreRemoteDataSourceImpl implements ProviderStoreRemoteDataSource {
  const ProviderStoreRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getStore() async {
    try {
      return await client.get(RemoteUrls.providerStore);
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: RemoteUrls.providerStore),
        statusCode: 200,
        data: _fallbackResponse,
      );
    }
  }
}

const Map<String, dynamic> _fallbackResponse = {
  'success': true,
  'message': '',
  'data': {
    'id': 'miilagry-store',
    'name': 'Miilagry Cake Shop',
    'name_en': 'Cake Shop',
    'category': 'حلويات',
    'location': 'الرياض',
    'cover_image_path': 'assets/images/home_banner.png',
    'about_description':
        'متجرنا على يقدم خدمات ومنتجات متجرنا على يقدم خدمات ومنتجات متجرنا على يقدم خدمات ومنتجات ..',
    'about_highlights': [],
    'whatsapp': '+966500000000',
    'categories': [
      {'id': 'all', 'name': 'All'},
      {'id': 'cake', 'name': 'كيك'},
    ],
    'products': [],
  },
};
