import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../abzar/seRagham.dart';
import '../../const.dart';
// import '../../controllers/task_controller.dart';
import '../../main.dart';

class AddFoodScreen extends StatefulWidget {
  static int groupid = 0;
  static int id = 0;
  static TextEditingController foodNameController = TextEditingController();
  static TextEditingController numberController = TextEditingController();
  static TextEditingController periceController = TextEditingController();
  static String dropdownValue = 'گرم';
  static bool isEdit = false;

  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String lableFood = '';
  final focusFoodName = FocusNode();
  final focusNumber = FocusNode();
  final focusPrice = FocusNode();
  var hiveBox = Hive.box<FoodModel>('foodBox');

  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: (SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 15, top: 30),
            child: Form(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: screenH < 600 ? 18 : 22,
                          //color: MyConst.backgroundColor400,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          AddFoodScreen.isEdit
                              ? 'ویرایش اطلاعات غذا'
                              : 'افزودن اطلاعات غذا',
                          style: TextStyle(
                            fontSize: screenH < 600 ? 12 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  //! text field description
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusNumber);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا نام کالا را وارد کنید';
                        }
                        return null;
                      },
                      maxLines: 1,
                      controller: AddFoodScreen.foodNameController,
                      textAlign: TextAlign.end,
                      focusNode: focusFoodName,
                      decoration: InputDecoration(
                        hintText: 'نام ماده غذایی',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  //! Deropdown
                  Row(
                    children: [
                      Expanded(
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                value: AddFoodScreen.dropdownValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    AddFoodScreen.dropdownValue = newValue!;
                                  });
                                },
                                items: <String>['گرم', 'عدد', 'پرس']
                                    .map<DropdownMenuItem<String>>(
                                        (dropdownValue) {
                                  return DropdownMenuItem<String>(
                                    value: dropdownValue,
                                    child: Text(dropdownValue,
                                        textAlign: TextAlign.start,
                                        //textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: screenH < 600 ? 14 : 18,
                                        )),
                                  );
                                }).toList())),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      //! text field vahed
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focusPrice);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'لطفا نام کالا را وارد کنید';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: AddFoodScreen.numberController,
                            textAlign: TextAlign.end,
                            focusNode: focusNumber,
                            decoration: InputDecoration(
                              hintText: 'مقدار و واحد را وارد کنید',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //! text field price
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter()
                      ],
                      focusNode: focusPrice,
                      controller: AddFoodScreen.periceController,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: '$lableFood تومان',
                        labelStyle: MyConst.style12_16(screenH)
                            .copyWith(color: Colors.black),
                        prefixText: 'تومان',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 1),
                      ),
                      onChanged: (v) {
                        lableFood = v.toWord();

                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا مبلغ را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),

                  //! elevated button
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //!

                        if (AddFoodScreen.foodNameController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(focusFoodName);
                          MotionToast.error(
                                  description:
                                      const Text('لطفا توضیحات را وارد کنید'))
                              .show(context);
                          return;
                        }

                        int randId = AddFoodScreen.isEdit
                            ? AddFoodScreen.id
                            : Random().nextInt(99999999);

                        FoodModel item = FoodModel(
                          id: randId,
                          title: AddFoodScreen.foodNameController.text,
                          amount: AddFoodScreen.numberController.text,
                          vahed: AddFoodScreen.dropdownValue,
                          fi: AddFoodScreen.periceController.text
                              .replaceAll(',', ''),
                          isChecked: false,
                        );

                        if (AddFoodScreen.isEdit) {
                          int index = 0;
                          MyApp.getFoodData();
                          for (int i = 0; i < hiveBox.values.length; i++) {
                            if (hiveBox.values.elementAt(i).id ==
                                AddFoodScreen.id) {
                              index = i;
                              break;
                            }
                          }
                          //setState(() {});
                          hiveBox.putAt(index, item);
                          MyApp.getFoodData();
                        } else {
                          //CalculatScreen.personList.add(item);
                          Get.find<CalculationController>().foodList.add(item);
                          hiveBox.add(item);
                        }

                        //!
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AddFoodScreen.isEdit
                              ? 'ویرایش اطلاعات'
                              : ' ثبت اطلاعات',
                          style: TextStyle(
                              fontSize: screenH < 600 ? 12 : 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
