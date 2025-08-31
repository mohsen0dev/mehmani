import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/main.dart';
import 'package:mehmani/screen/food/add_food.dart';

import 'package:mehmani/screen/home_page.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../const.dart';
// import '../../controllers/task_controller.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  Widget build(BuildContext context) {
    var getFood = Get.find<CalculationController>().foodList;
    return Scaffold(
      backgroundColor: MyConst.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MyConst.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_rounded,
                        color: MyConst.onPrimaryContainer,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اطلاعات غذایی ثبت شده',
                              style: MyConst.titleLarge(screenH).copyWith(
                                color: MyConst.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(() => Text(
                                  '${getFood.length} غذا ثبت شده',
                                  style: MyConst.bodyLarge(screenH).copyWith(
                                    color: MyConst.onPrimaryContainer
                                        .withOpacity(0.8),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // List Section
                Expanded(
                  child: Obx(
                    () => getFood.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: getFood.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: MyConst.secondaryContainer,
                                    child: Icon(
                                      Icons.restaurant_rounded,
                                      color: MyConst.onSecondaryContainer,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    '${getFood[index].title} ${getFood[index].amount} ${getFood[index].vahed}',
                                    style: MyConst.bodyLarge(screenH).copyWith(
                                      color: MyConst.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  subtitle: Text(
                                    '${getFood[index].fi.seRagham()} تومان',
                                    style: MyConst.bodyLarge(screenH).copyWith(
                                      color: MyConst.onSurfaceVariant,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          AddFoodScreen.isEdit = true;
                                          AddFoodScreen.id = getFood[index].id;
                                          AddFoodScreen.foodNameController
                                              .text = getFood[index].title;
                                          AddFoodScreen.numberController.text =
                                              getFood[index].amount;
                                          AddFoodScreen.dropdownValue =
                                              getFood[index].vahed;
                                          AddFoodScreen.periceController.text =
                                              getFood[index].fi;

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return AddFoodScreen();
                                          })));
                                        },
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          color: MyConst.primary,
                                        ),
                                        tooltip: 'ویرایش',
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showDeleteDialog(
                                              getFood[index], index);
                                        },
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: MyConst.error,
                                        ),
                                        tooltip: 'حذف',
                                      ),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 64,
            color: MyConst.onSurfaceVariant,
          ),
          SizedBox(height: 16),
          Text(
            'هیچ غذایی ثبت نشده است',
            style: MyConst.bodyLarge(screenH).copyWith(
              color: MyConst.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'برای شروع، غذا جدیدی اضافه کنید',
            style: MyConst.bodyLarge(screenH).copyWith(
              color: MyConst.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(FoodModel food, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: MyConst.surface,
          surfaceTintColor: MyConst.surfaceTint,
          title: Text(
            'حذف غذا',
            style: MyConst.titleLarge(screenH).copyWith(
              color: MyConst.onSurface,
            ),
            textDirection: TextDirection.rtl,
          ),
          content: RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              text: 'آیا از حذف ',
              style: MyConst.bodyLarge(screenH).copyWith(
                color: MyConst.onSurface,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: food.title,
                  style: TextStyle(
                    color: MyConst.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' اطمینان دارید؟',
                  style: MyConst.bodyLarge(screenH).copyWith(
                    color: MyConst.onSurface,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'خیر',
                style: MyConst.labelLarge(screenH).copyWith(
                  color: MyConst.primary,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            FilledButton(
              child: Text(
                'بله',
                style: MyConst.labelLarge(screenH).copyWith(
                  color: MyConst.onError,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: MyConst.error,
              ),
              onPressed: () {
                Get.back();
                setState(() {
                  Hive.box<FoodModel>('foodBox').deleteAt(index);
                  MyApp.getFoodData();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
