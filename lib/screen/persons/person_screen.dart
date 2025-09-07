import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/home_page.dart';

import '../../const.dart';
// import '../../controllers/task_controller.dart';
import '../../main.dart';
import '../models/person_model.dart';
import 'add_person.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key, required BuildContext mycontext})
      : super(key: key);

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext mycontext) {
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
                        Icons.group_rounded,
                        color: MyConst.onPrimaryContainer,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'خانوار ثبت شده',
                              style: MyConst.bodyLarge(screenH).copyWith(
                                color: MyConst.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(() => Text(
                                  '${Get.find<CalculationController>().personList.length} خانواده ثبت شده',
                                  style: MyConst.labelLarge(screenH).copyWith(
                                    color: MyConst.onPrimaryContainer
                                        .withValues(alpha: 0.8),
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
                    () => Get.find<CalculationController>().personList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: Get.find<CalculationController>()
                                .personList
                                .length,
                            itemBuilder: (context, index) {
                              var person = Get.find<CalculationController>()
                                  .personList[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: MyConst.primaryContainer,
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: MyConst.onPrimaryContainer,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    person.title,
                                    style: MyConst.bodyLarge(screenH).copyWith(
                                      color: MyConst.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${person.conter} نفر',
                                    style: MyConst.bodyLarge(screenH).copyWith(
                                      color: MyConst.onSurfaceVariant,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          AddPersonScreen.isEdit = true;
                                          AddPersonScreen.nameController.text =
                                              person.title;
                                          AddPersonScreen.numberController
                                              .text = person.conter;
                                          AddPersonScreen.id = person.id;

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return AddPersonScreen(
                                                buildContext: context);
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
                                          _showDeleteDialog(person, index);
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
            Icons.group_outlined,
            size: 64,
            color: MyConst.onSurfaceVariant,
          ),
          SizedBox(height: 16),
          Text(
            'هیچ خانواده‌ای ثبت نشده است',
            style: MyConst.bodyLarge(screenH).copyWith(
              color: MyConst.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'برای شروع، خانواده جدیدی اضافه کنید',
            style: MyConst.labelLarge(screenH).copyWith(
              color: MyConst.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(PersonModel person, int index) {
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
            'حذف خانوار',
            style: MyConst.titleLarge(screenH).copyWith(
              color: MyConst.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
          content: RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              text: 'آیا مطمئن هستید که میخواهید ',
              style: MyConst.bodyLarge(screenH).copyWith(
                color: MyConst.onSurface,
              ),
              children: [
                TextSpan(
                  text: person.title,
                  style: TextStyle(
                    color: MyConst.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' را حذف کنید؟',
                  style: MyConst.bodyLarge(screenH).copyWith(
                    color: MyConst.onSurface,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
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
                  Hive.box<PersonModel>('personBox').deleteAt(index);
                  MyApp.getPersonData();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
