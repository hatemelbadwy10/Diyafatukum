import 'package:equatable/equatable.dart';

List<ReferenceModel> referencesFromJson(List<dynamic> json) {
  return json.map((e) => ReferenceModel.fromJson(e)).toList();
}

class ReferenceModel extends Equatable {
  final int id;
  final String? value;

  const ReferenceModel({this.value, required this.id});

  factory ReferenceModel.fromJson(Map<String, dynamic> json, {String labelKey = 'name'}) {
    return ReferenceModel(id: json['id'] as int, value: json[labelKey]?.toString() ?? '');
  }

  Map<String, dynamic> toJson({String labelKey = 'value'}) {
    return {'id': id, labelKey: value};
  }

  @override
  List<Object?> get props => [value, id];
}
