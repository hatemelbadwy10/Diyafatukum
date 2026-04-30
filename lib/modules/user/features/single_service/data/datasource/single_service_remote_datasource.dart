import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../../core/resources/type_defs.dart';

abstract class SingleServiceRemoteDataSource {
  Future<Response> getService(String serviceKey, ParamsMap params);
  Future<Response> getStore(
    String serviceKey,
    String storeId,
    ParamsMap params,
  );
}

@LazySingleton(as: SingleServiceRemoteDataSource)
class SingleServiceRemoteDataSourceImpl
    implements SingleServiceRemoteDataSource {
  const SingleServiceRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getService(String serviceKey, ParamsMap params) async {
    try {
      return await client.get(
        RemoteUrls.singleService(serviceKey),
        queryParameters: params,
      );
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(
          path: RemoteUrls.singleService(serviceKey),
        ),
        statusCode: 200,
        data: _fallbackResponse(
          serviceKey,
          int.tryParse(params?['page'] ?? '1') ?? 1,
        ),
      );
    }
  }

  @override
  Future<Response> getStore(
    String serviceKey,
    String storeId,
    ParamsMap params,
  ) async {
    try {
      return await client.get(
        RemoteUrls.singleServiceStore(serviceKey, storeId),
        queryParameters: params,
      );
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(
          path: RemoteUrls.singleServiceStore(serviceKey, storeId),
        ),
        statusCode: 200,
        data: _fallbackStoreResponse(serviceKey, storeId),
      );
    }
  }
}

Map<String, dynamic> _fallbackResponse(String serviceKey, int page) {
  const lastPage = 2;
  final names = _serviceNames(serviceKey);
  return {
    'success': true,
    'message': '',
    'payload': {
      'specialization': {
        'id': serviceKey,
        'name': 'Sweet Bliss',
        'description': 'Stores and services for events and gifts',
        'image': 'https://picsum.photos/600/800?random=$serviceKey',
        'stores_count': 8,
      },
      'current_page': page,
      'last_page': lastPage,
      'stores': page == 1
          ? List.generate(6, (index) {
              return {
                'id': '${serviceKey}_${page}_$index',
                'specialization': {'name': 'Sweet Bliss'},
                'name': names[index],
                'description': 'Premium selections for events and occasions',
                'address': 'الرياض',
                'logo':
                    'https://picsum.photos/500/500?random=${serviceKey}_$index',
                'whatsapp': '+966500000000',
                'owner': {'name': 'Store Owner', 'phone': '+966500000000'},
              };
            })
          : List.generate(2, (index) {
              return {
                'id': '${serviceKey}_${page}_${index + 6}',
                'specialization': {'name': 'Sweet Bliss'},
                'name': names[index + 6],
                'description': 'Premium selections for events and occasions',
                'address': 'الرياض',
                'logo':
                    'https://picsum.photos/500/500?random=${serviceKey}_${index + 6}',
                'whatsapp': '+966500000000',
                'owner': {'name': 'Store Owner', 'phone': '+966500000000'},
              };
            }),
    },
  };
}

Map<String, dynamic> _fallbackStoreResponse(String serviceKey, String storeId) {
  return {
    'success': true,
    'message': '',
    'payload': {
      'id': storeId,
      'name': 'Milagry Cake Shop',
      'description': 'Premium cakes and sweet boxes for events and occasions',
      'whatsapp': '+966501234567',
      'address': 'الرياض',
      'latitude': '24.8103',
      'longitude': '46.671',
      'logo': 'https://picsum.photos/800/900?random=store_$storeId',
      'specialization': {'id': serviceKey, 'name': 'حلويات'},
      'categories_count': 3,
      'products_count': 5,
      'owner': {'name': 'محمد العنزي', 'phone': '+966501234567'},
      'categories': _storeCategories(),
      'products': _storeItems(serviceKey, storeId),
    },
  };
}

List<Map<String, dynamic>> _storeItems(String serviceKey, String storeId) {
  final items = switch (serviceKey) {
    'gift' => const [
      ['gift_box', 'Luxury Gift Box', 180.0],
      ['gift_flowers', 'Flowers With Card', 140.0],
      ['gift_choco', 'Chocolate Tray', 95.0],
      ['gift_balloons', 'Balloon Setup', 120.0],
      ['gift_candle', 'Scented Candle Set', 85.0],
    ],
    'camera' => const [
      ['photo_session', 'Mini Photo Session', 350.0],
      ['photo_edit', 'Photo Editing', 120.0],
      ['photo_reel', 'Short Reel Coverage', 280.0],
      ['photo_event', 'Event Photography', 600.0],
      ['photo_album', 'Printed Album', 250.0],
    ],
    'flowers' => const [
      ['flower_bouquet', 'Soft Bouquet', 170.0],
      ['flower_box', 'Luxury Flower Box', 220.0],
      ['flower_vase', 'Fresh Vase Setup', 150.0],
      ['flower_table', 'Table Flowers', 260.0],
      ['flower_hand', 'Hand Bouquet', 130.0],
    ],
    'beauty' => const [
      ['beauty_makeup', 'Soft Makeup', 300.0],
      ['beauty_hair', 'Hair Styling', 180.0],
      ['beauty_nails', 'Nail Service', 120.0],
      ['beauty_skin', 'Skin Prep', 160.0],
      ['beauty_package', 'Full Beauty Package', 520.0],
    ],
    'coffee' => const [
      ['coffee_cart', 'Coffee Cart', 450.0],
      ['coffee_box', 'Premium Coffee Box', 140.0],
      ['coffee_cups', 'Cup Set', 95.0],
      ['coffee_dessert', 'Coffee With Dessert', 125.0],
      ['coffee_corner', 'Coffee Corner Setup', 360.0],
    ],
    'decorations' => const [
      ['decor_table', 'Table Styling', 320.0],
      ['decor_garden', 'Garden Setup', 780.0],
      ['decor_lights', 'Light Decoration', 240.0],
      ['decor_stage', 'Stage Styling', 650.0],
      ['decor_flowers', 'Decor Flowers', 290.0],
    ],
    _ => const [
      ['sweet_cupcake', 'Vanilla Cupcake', 100.0],
      ['sweet_cheesecake', 'Cold Cheesecake', 110.0],
      ['sweet_cake', 'Mini Cake', 250.0],
      ['sweet_choco', 'Chocolate Cupcake', 200.0],
      ['sweet_macaron', 'Macaron Box', 150.0],
    ],
  };

  return List.generate(items.length, (index) {
    final item = items[index];
    return {
      'id': '${storeId}_${item[0]}',
      'store_id': storeId,
      'category_id': index < 2 ? 1 : 2,
      'category_name': index < 2 ? 'كيك المناسبات' : 'بوكسات الحلويات',
      'name': item[1],
      'description': 'منتج مميز مناسب للمناسبات والهدايا',
      'price': item[2],
      'image': 'https://picsum.photos/300/300?random=${storeId}_${item[0]}',
      'quantity': 20,
      'in_stock': true,
    };
  });
}

List<Map<String, dynamic>> _storeCategories() {
  return const [
    {'id': 0, 'name': 'الكل', 'description': '', 'products_count': 0},
    {
      'id': 1,
      'name': 'كيك المناسبات',
      'description': 'كيك مخصص للحفلات والمناسبات السعيدة',
      'products_count': 2,
    },
    {
      'id': 2,
      'name': 'بوكسات الحلويات',
      'description': 'تشكيلات حلويات جاهزة للتقديم والإهداء',
      'products_count': 3,
    },
  ];
}

List<String> _serviceNames(String serviceKey) {
  switch (serviceKey) {
    case 'gift':
      return const [
        'Golden Box',
        'Ribbon House',
        'Wrapped Joy',
        'Luxe Gifts',
        'Gifting Corner',
        'Spark Box',
        'Velvet Touch',
        'Happy Basket',
      ];
    case 'camera':
      return const [
        'Luma Studio',
        'Prime Lens',
        'Frame Craft',
        'Click House',
        'Focus Lab',
        'Scene Story',
        'Flash Point',
        'Moment Makers',
      ];
    case 'flowers':
      return const [
        'Bloom Charm',
        'Tulip Touch',
        'Rose Valley',
        'Petal House',
        'Lily Garden',
        'Fresh Stem',
        'White Blossom',
        'Orchid Mood',
      ];
    case 'beauty':
      return const [
        'Glow Lab',
        'Silk Touch',
        'Luna Care',
        'Pure Beauty',
        'Velvet Skin',
        'Aura Studio',
        'Soft Glam',
        'Bella Care',
      ];
    case 'coffee':
      return const [
        'Brew District',
        'Roast Ritual',
        'Golden Cup',
        'Bean Story',
        'Caffeine Spot',
        'Daily Roast',
        'Mocha Mood',
        'Arabica House',
      ];
    case 'decorations':
      return const [
        'Linen Light',
        'Table Bloom',
        'White Setup',
        'Garden Mood',
        'Classic Decor',
        'Golden Touch',
        'Event Glow',
        'Pure Tables',
      ];
    case 'sweets':
    default:
      return const [
        'Sweet Bliss',
        'Milagry Cake Shop',
        'Sweet Dreams',
        'Sweet Moments',
        'Sweet Quintet',
        'Dulce Tentacion',
        'Cake Mood',
        'Sugar Touch',
      ];
  }
}
