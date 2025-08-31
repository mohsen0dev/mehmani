import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../const.dart';
// import '../controllers/task_controller.dart';
import '../main.dart';
import '../screen/home_page.dart';
import '../screen/models/food_model.dart';
import '../screen/models/person_model.dart';

Future<File> get localFile async {
  final path = await ('storage/emulated/0/mehmoni_backup');
  return File('$path/backup.json');
}

Future<File> addPeople({people, foods, required BuildContext context}) async {
  people.clear();
  foods.clear();
  Box<PersonModel> hiveBox = Hive.box<PersonModel>('personBox');
  Box<FoodModel> foodBox = Hive.box<FoodModel>('foodBox');
  people.addAll(hiveBox.values);
  foods.addAll(foodBox.values);
  return writePeople(people: people, food: foods, context: context);
}

//!
Future<File> writePeople({people, food, BuildContext? context}) async {
  if (await Permission.storage.request().isGranted) {
    final file = await localFile;
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    String encodedPeople = jsonEncode(people);
    String encodedFood = jsonEncode(food);
    myToastsuccessMetod(text: 'فایل پشتیبان با موفقیت ایجاد شد').show(context!);
    return file.writeAsString(encodedPeople + '\n' + encodedFood);
  } else {
    myToastErrorMetod(text: 'دسترسی به حافظه را تایید کنید').show(context!);
    return Future.error('Permission denied');
  }
}

//!
Future readPeople(
    {required List<PersonModel> people,
    required List<FoodModel> foods,
    BuildContext? context}) async {
  if (!await Permission.storage.request().isGranted) {
    MotionToast.error(
      layoutOrientation: TextDirection.rtl,
      toastDuration: Duration(seconds: 3),
      width: screenW,
      title: Text('عملیات ناموفق بود', style: MyConst.style12_16(Get.height)),
      toastAlignment: Alignment.bottomCenter,
      description: Text(
        'دسترسی به حافظه را تایید کنید',
      ),
    ).show(context!);
  } else {
    people.clear();
    foods.clear();
    var importedPeople = await readPeoplee(context: context);
    people = importedPeople;
    var importedFood = await readFood(context: context);
    foods = importedFood;
  }
}

//! read people from file
Future<List<PersonModel>> readPeoplee(
    {bool local = true, File? selectedFile, BuildContext? context}) async {
  var hiveBox = Hive.box<PersonModel>('personBox');
  hiveBox.clear();
  try {
    File file;
    if (local) {
      file = await localFile;
    } else {
      file = selectedFile!;
    }
    final List jsonContents = await file.readAsLines();
    List<dynamic> jsonResponse = json.decode(jsonContents[0]);
    return jsonResponse.map((i) {
      PersonModel item = PersonModel(
        id: PersonModel.fromJson(i).id,
        title: PersonModel.fromJson(i).title,
        conter: PersonModel.fromJson(i).conter,
        isChecked: PersonModel.fromJson(i).isChecked,
      );
      MyApp.getPersonData();
      Get.find<CalculationController>().personList.add(item);
      hiveBox.add(item);
      return PersonModel.fromJson(i);
    }).toList();
  } catch (e) {
    myToastErrorMetod(text: 'عملیات ناموفق بود').show(context!);
    return [];
  }
}

//! readFood
Future<List<FoodModel>> readFood(
    {bool local = true, File? selectedFile, BuildContext? context}) async {
  var hiveBox = Hive.box<FoodModel>('foodBox');
  hiveBox.clear();
  try {
    File file;
    if (local) {
      file = await localFile;
    } else {
      file = selectedFile!;
    }
    final List jsonContents = await file.readAsLines();
    List<dynamic> jsonResponse = json.decode(jsonContents[1]);
    return jsonResponse.map((i) {
      FoodModel item = FoodModel(
        id: FoodModel.fromJson(i).id,
        title: FoodModel.fromJson(i).title,
        amount: FoodModel.fromJson(i).amount,
        isChecked: FoodModel.fromJson(i).isChecked,
        fi: FoodModel.fromJson(i).fi,
        vahed: FoodModel.fromJson(i).vahed,
      );
      MyApp.getFoodData();
      Get.find<CalculationController>().foodList.add(item);
      hiveBox.add(item);
      myToastsuccessMetod(text: 'لطفا برنامه را مجدد اجرا کنید').show(context!);
      return FoodModel.fromJson(i);
    }).toList(); // 5
  } catch (e) {
    myToastErrorMetod(text: 'عملیات ناموفق بود').show(context!);
    return [];
  }
}

MotionToast myToastErrorMetod({String? text}) {
  return MotionToast.error(
    // dismissable: false,
    layoutOrientation: TextDirection.rtl,
    toastDuration: Duration(seconds: 3),
    width: screenW,
    title: Text('عملیات ناموفق بود', style: MyConst.style12_16(screenH)),
    toastAlignment: Alignment.bottomCenter,
    description: Text(text!, style: MyConst.style11_15(screenH)),
  );
}

MotionToast myToastsuccessMetod({String? text}) {
  return MotionToast.success(
      layoutOrientation: TextDirection.rtl,
      toastDuration: Duration(seconds: 3),
      width: screenW * 0.9,
      title:
          Text('عملیات با موفقیت ثبت شد', style: MyConst.style12_16(screenH)),
      toastAlignment: Alignment.bottomCenter,
      description: Text(text!, style: MyConst.style11_15(screenH)));
}
