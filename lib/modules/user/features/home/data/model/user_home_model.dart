import 'package:equatable/equatable.dart';

UserHomeModel userHomeFromJson(dynamic json) => UserHomeModel.fromJson(json as Map<String, dynamic>);

class UserHomeModel extends Equatable {
  const UserHomeModel({
    required this.searchHintKey,
    required this.bannerTitleKey,
    required this.bannerActionKey,
    required this.featuredTitleKey,
    required this.featuredSubtitleKey,
    required this.shopNowKey,
    required this.services,
  });

  final String searchHintKey;
  final String bannerTitleKey;
  final String bannerActionKey;
  final String featuredTitleKey;
  final String featuredSubtitleKey;
  final String shopNowKey;
  final List<UserHomeServiceModel> services;

  factory UserHomeModel.fromJson(Map<String, dynamic> json) {
    return UserHomeModel(
      searchHintKey: json['search_hint_key'] ?? '',
      bannerTitleKey: json['banner_title_key'] ?? '',
      bannerActionKey: json['banner_action_key'] ?? '',
      featuredTitleKey: json['featured_title_key'] ?? '',
      featuredSubtitleKey: json['featured_subtitle_key'] ?? '',
      shopNowKey: json['shop_now_key'] ?? '',
      services: userHomeServicesFromJson(json['services'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'search_hint_key': searchHintKey,
      'banner_title_key': bannerTitleKey,
      'banner_action_key': bannerActionKey,
      'featured_title_key': featuredTitleKey,
      'featured_subtitle_key': featuredSubtitleKey,
      'shop_now_key': shopNowKey,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        searchHintKey,
        bannerTitleKey,
        bannerActionKey,
        featuredTitleKey,
        featuredSubtitleKey,
        shopNowKey,
        services,
      ];
}

List<UserHomeServiceModel> userHomeServicesFromJson(dynamic json) {
  return List<UserHomeServiceModel>.from(
    (json as List).map((item) => UserHomeServiceModel.fromJson(item as Map<String, dynamic>)),
  );
}

class UserHomeServiceModel extends Equatable {
  const UserHomeServiceModel({
    required this.titleKey,
    required this.iconKey,
    required this.imagePath,
  });

  final String titleKey;
  final String iconKey;
  final String imagePath;

  factory UserHomeServiceModel.fromJson(Map<String, dynamic> json) {
    return UserHomeServiceModel(
      titleKey: json['title_key'] ?? '',
      iconKey: json['icon_key'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title_key': titleKey,
      'icon_key': iconKey,
      'image_path': imagePath,
    };
  }

  @override
  List<Object?> get props => [titleKey, iconKey, imagePath];
}
