import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 0)
class PersonModel {
  @HiveField(1)
  int id = 0;
  @HiveField(2)
  String title = '';
  @HiveField(3)
  String conter = '';
  @HiveField(4)
  bool isChecked = false;
  PersonModel({
    required this.id,
    required this.title,
    required this.conter,
    required this.isChecked,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    // 1
    return PersonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      conter: json['conter'] as String,
      isChecked: json['isChecked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'conter': this.conter,
      'isChecked': this.isChecked,
    };
  }
}
