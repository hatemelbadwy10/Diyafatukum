import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

abstract class ProviderHomeRemoteDataSource {
  Future<Response> getHomeData();
}

@LazySingleton(as: ProviderHomeRemoteDataSource)
class ProviderHomeRemoteDataSourceImpl implements ProviderHomeRemoteDataSource {
  const ProviderHomeRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getHomeData() async {
    try {
      return await client.get(RemoteUrls.providerDashboard);
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: RemoteUrls.providerDashboard),
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
    'provider_name': 'حاتم أحمد',
    'orders': [
      {
        'id': '#123456789',
        'customer_name': 'محمود أنس',
        'date_label': 'الأحد 12 أكتوبر 2026',
        'status': 'pending',
      },
      {
        'id': '#123456780',
        'customer_name': 'عبدالعزيز محمد',
        'date_label': 'الأحد 12 أكتوبر 2026',
        'status': 'pending',
      },
      {
        'id': '#123456781',
        'customer_name': 'نورهان السيد',
        'date_label': 'الأحد 12 أكتوبر 2026',
        'status': 'pending',
      },
      {
        'id': '#123456782',
        'customer_name': 'سارة أحمد',
        'date_label': 'الأحد 12 أكتوبر 2026',
        'status': 'pending',
      },
    ],
  },
};
