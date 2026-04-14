import 'package:equatable/equatable.dart';

class ForgetPasswordModel extends Equatable {

  final int id;
  final String name;

  const ForgetPasswordModel({required this.id, required this.name});

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) => ForgetPasswordModel(id: json["id"], name: json['name']);



  @override
  List<Object> get props => [id,name];
}
