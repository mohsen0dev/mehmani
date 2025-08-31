import 'package:hive/hive.dart';

part 'food_model.g.dart';
//flutter packages pub run build_runner build

@HiveType(typeId: 1)
class FoodModel {
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  String amount;
  @HiveField(4)
  String vahed;
  @HiveField(5)
  String fi;
  @HiveField(6)
  bool isChecked = false;
  FoodModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.vahed,
    required this.fi,
    required this.isChecked,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    // 1
    return FoodModel(
        id: json['id'] as int,
        title: json['title'] as String,
        amount: json['amount'] as String,
        vahed: json['vahed'] as String,
        fi: json['fi'] as String,
        isChecked: json['isChecked'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'amount': this.amount,
      'vahed': this.vahed,
      'fi': this.fi,
      'isChecked': this.isChecked,
    };
  }
}
