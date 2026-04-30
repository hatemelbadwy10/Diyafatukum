import 'package:equatable/equatable.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';

UserHomeModel userHomeFromJson(dynamic json) =>
    UserHomeModel.fromJson(json as Map<String, dynamic>);

class UserHomeModel extends Equatable {
  const UserHomeModel({
    required this.banners,
    required this.services,
  });

  final List<UserHomeBannerModel> banners;
  final List<UserHomeServiceModel> services;

  factory UserHomeModel.fromJson(Map<String, dynamic> json) {
    return UserHomeModel(
      banners: userHomeBannersFromJson(json['banner'] ?? []),
      services: userHomeServicesFromJson(json['specializations'] ?? []),
    );
  }

  @override
  List<Object?> get props => [banners, services];
}

List<UserHomeBannerModel> userHomeBannersFromJson(dynamic json) {
  return List<UserHomeBannerModel>.from(
    (json as List).map(
      (item) => UserHomeBannerModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class UserHomeBannerModel extends Equatable {
  const UserHomeBannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  String get plainDescription => description.stripHtmlTags;

  factory UserHomeBannerModel.fromJson(Map<String, dynamic> json) {
    return UserHomeBannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      link: json['link'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, link];
}

List<UserHomeServiceModel> userHomeServicesFromJson(dynamic json) {
  return List<UserHomeServiceModel>.from(
    (json as List).map(
      (item) => UserHomeServiceModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class UserHomeServiceModel extends Equatable {
  const UserHomeServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.mobileIconUrl,
    required this.storesCount,
  });

  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String mobileIconUrl;
  final int storesCount;

  String get serviceKey => id.toString();

  factory UserHomeServiceModel.fromJson(Map<String, dynamic> json) {
    return UserHomeServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      mobileIconUrl: json['mobile_icon'] ?? '',
      storesCount: json['stores_count'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        mobileIconUrl,
        storesCount,
      ];
}
