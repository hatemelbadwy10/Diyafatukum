import 'package:equatable/equatable.dart';

class SplashModel extends Equatable {

  final int id;
  final String name;

  const SplashModel({required this.id, required this.name});

  factory SplashModel.fromJson(Map<String, dynamic> json) => SplashModel(id: json["id"], name: json['name']);



  @override
  List<Object> get props => [id,name];
}
