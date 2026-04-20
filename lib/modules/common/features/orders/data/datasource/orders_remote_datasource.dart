import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

abstract class OrdersRemoteDataSource {
  Future<Response> getOrders();
}

@LazySingleton(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  const OrdersRemoteDataSourceImpl(this.client);
  
  final ApiClient client;

  @override
  Future<Response> getOrders() async {
    try {
      return await client.get(RemoteUrls.orders);
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: RemoteUrls.orders),
        statusCode: 200,
        data: _fallbackResponse,
      );
    }
  }
}

const Map<String, dynamic> _fallbackResponse = {
  'success': true,
  'message': '',
  'data': [
    {
      'id': '#123456789',
      'store_name': 'Miilagry Cake Shop',
      'store_image_path': 'assets/images/logo_store_light.png',
      'store_phone': '050123456782',
      'items_summary': [
        '2x كب كيك فانيلا',
        '1x كيكة مرتفع (6 إنش)',
        '1x كب كيك شوكولاتة',
      ],
      'date_label': 'الأحد 12 أكتوبر 2026',
      'address': 'شارع الروضة، الرياض',
      'notes': 'ملاحظات',
      'total_paid': 500,
      'tab_status': 'current',
      'active_stage': 'processing',
    },
    {
      'id': '#278940598',
      'store_name': 'Flowers Shop',
      'store_image_path': 'assets/images/logo_bonus_light.png',
      'store_phone': '050123456783',
      'items_summary': [
        '3x ورد أبيض فاخر',
        '1x باقة ورد وردي',
      ],
      'date_label': 'الأحد 12 أكتوبر 2026',
      'address': 'طريق الملك فهد، الرياض',
      'notes': 'تغليف هدية',
      'total_paid': 320,
      'tab_status': 'completed',
      'active_stage': 'delivered',
    },
    {
      'id': '#657849321',
      'store_name': 'Coffee Shop',
      'store_image_path': 'assets/images/logo_b_light.png',
      'store_phone': '050123456784',
      'items_summary': [
        '2x قهوة لاتيه',
        '1x كوكيز شوكولاتة',
      ],
      'date_label': 'الأحد 12 أكتوبر 2026',
      'address': 'حي النخيل، الرياض',
      'notes': 'بدون سكر',
      'total_paid': 180,
      'tab_status': 'cancelled',
      'active_stage': 'received',
    },
  ],
};
