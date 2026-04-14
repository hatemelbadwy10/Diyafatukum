import 'package:equatable/equatable.dart';

List<FaqModel> faqsModelFromJson(dynamic json) {
  return (json['data'] as List).map((e) => FaqModel.fromJson(e)).toList();
}

FaqModel faqModelFromJson(dynamic json) {
  return FaqModel.fromJson(json);
}

class FaqModel extends Equatable {
  final int id;
  final String question;
  final String answer;

  const FaqModel({required this.id, required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(id: json['id'] as int, question: json['question'] as String, answer: json['answer'] as String);
  }

  @override
  List<Object?> get props => [id, question, answer];
}
