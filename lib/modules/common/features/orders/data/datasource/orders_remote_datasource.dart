import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../model/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<Response> getOrders(OrderTabStatus status);
}

@LazySingleton(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  const OrdersRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getOrders(OrderTabStatus status) async {
    try {
      return await client.get(
        RemoteUrls.orders,
        queryParameters: {'tab': status.name},
      );
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: RemoteUrls.orders),
        statusCode: 200,
        data: _fallbackResponse(status),
      );
    }
  }
}

Map<String, dynamic> _fallbackResponse(OrderTabStatus status) => {
  'success': true,
  'message': '',
  'data': [
    if (status == OrderTabStatus.current)
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
    if (status == OrderTabStatus.completed)
      {
        'id': '#278940598',
        'store_name': 'Flowers Shop',
        'store_image_path': 'assets/images/logo_bonus_light.png',
        'store_phone': '050123456783',
        'items_summary': ['3x ورد أبيض فاخر', '1x باقة ورد وردي'],
        'date_label': 'الأحد 12 أكتوبر 2026',
        'address': 'طريق الملك فهد، الرياض',
        'notes': 'تغليف هدية',
        'total_paid': 320,
        'tab_status': 'completed',
        'active_stage': 'delivered',
      },
    if (status == OrderTabStatus.cancelled)
      {
        'id': '#657849321',
        'store_name': 'Coffee Shop',
        'store_image_path': 'assets/images/logo_b_light.png',
        'store_phone': '050123456784',
        'items_summary': ['2x قهوة لاتيه', '1x كوكيز شوكولاتة'],
        'date_label': 'الأحد 12 أكتوبر 2026',
        'address': 'حي النخيل، الرياض',
        'notes': 'بدون سكر',
        'total_paid': 180,
        'tab_status': 'cancelled',
        'active_stage': 'received',
      },
  ],
};
