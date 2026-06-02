import 'package:equatable/equatable.dart';

List<ProviderSpecializationModel> providerSpecializationsFromJson(
  dynamic json,
) {
  return List<ProviderSpecializationModel>.from(
    (json as List).map(
      (item) =>
          ProviderSpecializationModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderSpecializationModel extends Equatable {
  const ProviderSpecializationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;

  factory ProviderSpecializationModel.fromJson(Map<String, dynamic> json) {
    return ProviderSpecializationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl];
}
