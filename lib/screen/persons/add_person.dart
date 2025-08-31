import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/home_page.dart';
import 'package:mehmani/screen/models/person_model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mehmani/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import '../../controllers/task_controller.dart';

class AddPersonScreen extends StatefulWidget {
  static int groupid = 0;
  static int id = 0;
  static TextEditingController nameController = TextEditingController();
  static TextEditingController numberController = TextEditingController();
  static bool isEdit = false;
  const AddPersonScreen({Key? key, required BuildContext buildContext})
      : super(key: key);

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  @override
  Widget build(BuildContext context) {
    final focusFamilyName = FocusNode();
    final focusFamilyNumber = FocusNode();
    var hiveBox = Hive.box<PersonModel>('personBox');

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
                          AddPersonScreen.isEdit
                              ? 'ویرایش اطلاعات خانوار'
                              : 'افزودن اطلاعات خانوار',
                          style: TextStyle(
                            fontSize: screenH < 600 ? 12 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  //! text field name family
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusFamilyName);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'نام خانواده را وارد کنید';
                        }
                        return null;
                      },
                      maxLines: 1,
                      controller: AddPersonScreen.nameController,
                      textAlign: TextAlign.end,
                      focusNode: focusFamilyName,
                      decoration: InputDecoration(
                        hintText: 'نام خانواده را وارد کنید',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  Directionality(
                    textDirection: TextDirection.rtl,
                    child:

                        //! text field vahed
                        Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context)
                              .requestFocus(focusFamilyNumber);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'تعداد افراد را وارد کنید';
                          }
                          return null;
                        },
                        maxLines: 1,
                        controller: AddPersonScreen.numberController,
                        focusNode: focusFamilyNumber,
                        decoration: InputDecoration(
                          hintText: 'تعداد افراد را وارد کنید',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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

                        if (AddPersonScreen.nameController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(focusFamilyName);
                          MotionToast.error(
                                  description:
                                      const Text('لطفا توضیحات را وارد کنید'))
                              .show(context);
                          return;
                        }

                        int randId = AddPersonScreen.isEdit
                            ? AddPersonScreen.id
                            : Random().nextInt(99999999);

                        PersonModel item = PersonModel(
                          id: randId,
                          title: AddPersonScreen.nameController.text,
                          conter: AddPersonScreen.numberController.text,
                          isChecked: false,
                        );

                        if (AddPersonScreen.isEdit) {
                          int index = 0;
                          MyApp.getPersonData();
                          for (int i = 0; i < hiveBox.values.length; i++) {
                            if (hiveBox.values.elementAt(i).id ==
                                AddPersonScreen.id) {
                              index = i;
                              break;
                            }
                          }

                          hiveBox.putAt(index, item);
                          MyApp.getPersonData();
                          //CalculatScreen.personList[AddPersonScreen.] =item;
                        } else {
                          //CalculatScreen.personList.add(item);
                          Get.find<CalculationController>()
                              .personList
                              .add(item);
                          hiveBox.add(item);
                        }
                        //!

                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AddPersonScreen.isEdit
                              ? 'ذخیره اطلاعات'
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
