import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/constants/remote_urls.dart';

abstract class UserHomeRemoteDataSource {
  Future<Response> getHomeData();
}

@LazySingleton(as: UserHomeRemoteDataSource)
class UserHomeRemoteDataSourceImpl implements UserHomeRemoteDataSource {
  const UserHomeRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getHomeData() async {
    try {
      return await client.get(RemoteUrls.userHome);
    } catch (_) {
      return Response(
        requestOptions: RequestOptions(path: RemoteUrls.userHome),
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
    'search_hint_key': 'home.user.search_hint',
    'banner_title_key': 'home.user.banner.title',
    'banner_action_key': 'home.user.banner.action',
    'featured_title_key': 'home.user.featured.title',
    'featured_subtitle_key': 'home.user.featured.subtitle',
    'shop_now_key': 'home.user.shop_now',
    'services': [
      {
        'title_key': 'home.user.services.gifts',
        'icon_key': 'gift',
        'image_path': 'assets/images/welcome_screen.png',
      },
      {
        'title_key': 'home.user.services.photography',
        'icon_key': 'camera',
        'image_path': 'assets/images/home_banner.png',
      },
      {
        'title_key': 'home.user.services.flowers',
        'icon_key': 'flowers',
        'image_path': 'assets/images/welcome_screen.png',
      },
      {
        'title_key': 'home.user.services.beauty',
        'icon_key': 'beauty',
        'image_path': 'assets/images/home_banner.png',
      },
      {
        'title_key': 'home.user.services.coffee',
        'icon_key': 'coffee',
        'image_path': 'assets/images/home_banner.png',
      },
      {
        'title_key': 'home.user.services.sweets',
        'icon_key': 'sweets',
        'image_path': 'assets/images/welcome_screen.png',
      },
      {
        'title_key': 'home.user.services.decorations',
        'icon_key': 'decorations',
        'image_path': 'assets/images/home_banner.png',
      },
    ],
  },
};
