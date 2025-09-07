import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehmani/const.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/home_page.dart';
import 'package:mehmani/screen/models/person_model.dart';
import 'package:mehmani/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import '../../controllers/task_controller.dart';

class AddPersonScreen extends StatefulWidget {
  // static int groupid = 0;
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
  final _formKey = GlobalKey<FormState>();
  final focusFamilyName = FocusNode();
  final focusFamilyNumber = FocusNode();
  var hiveBox = Hive.box<PersonModel>('personBox');

  @override
  void dispose() {
    focusFamilyName.dispose();
    focusFamilyNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 15, top: 30),
            child: Form(
              key: _formKey,
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
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusFamilyName);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفاً نام را وارد کنید';
                          }
                          if (value.length < 2) {
                            return 'نام باید حداقل ۲ حرف باشد';
                          }
                          return null;
                        },
                        maxLines: 1,
                        controller: AddPersonScreen.nameController,
                        // textAlign: TextAlign.end,
                        focusNode: focusFamilyName,
                        decoration: InputDecoration(
                          labelText: 'نام خانواده ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: MyConst.backgroundColor400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child:
                        //! text field vahed
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'تعداد افراد را وارد کنید';
                              }
                              if (int.tryParse(value) == null) {
                                return 'لطفاً یک عدد معتبر وارد کنید';
                              }
                              if (int.parse(value) <= 0) {
                                return 'تعداد باید بیشتر از صفر باشد';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: AddPersonScreen.numberController,
                            focusNode: focusFamilyNumber,
                            decoration: InputDecoration(
                              labelText: 'تعداد افراد ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: Icon(
                                Icons.numbers,
                                color: MyConst.backgroundColor400,
                              ),
                            ),
                          ),
                        ),
                  ),

                  //! elevated button
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,

                      // onPressed: () {
                      //   //!

                      //   if (AddPersonScreen.nameController.text.isEmpty) {
                      //     FocusScope.of(context).requestFocus(focusFamilyName);
                      //     Get.showSnackbar(GetSnackBar(
                      //       messageText: const Text(
                      //         'لطفا نام را وارد کنید',
                      //         textAlign: TextAlign.right,
                      //       ),
                      //       // messageText: 'لطفا نام را وارد کنید',
                      //       duration: Duration(seconds: 3),
                      //       backgroundColor:
                      //           MyConst.error.withValues(alpha: 0.7),
                      //     ));
                      //     // MotionToast.error(
                      //     //         toastAlignment: Alignment.topCenter,
                      //     //         description:
                      //     //             const Text('لطفا نام را وارد کنید'))
                      //     //     .show(context);
                      //     return;
                      //   }
                      //   if (AddPersonScreen.numberController.text.isEmpty) {
                      //     FocusScope.of(context)
                      //         .requestFocus(focusFamilyNumber);
                      //     Get.showSnackbar(GetSnackBar(
                      //       messageText: const Text(
                      //         'تعداد افراد را وارد کنید',
                      //         textAlign: TextAlign.right,
                      //       ),
                      //       duration: Duration(seconds: 3),
                      //       backgroundColor:
                      //           MyConst.error.withValues(alpha: 0.7),
                      //     ));
                      //     // MotionToast.error(
                      //     //         toastAlignment: Alignment.topCenter,
                      //     //         description:
                      //     //             const Text('تعداد افراد را وارد کنید'))
                      //     //     .show(context);
                      //     return;
                      //   }

                      //   PersonModel item = PersonModel(
                      //     id: randId,
                      //     title: AddPersonScreen.nameController.text,
                      //     conter: AddPersonScreen.numberController.text,
                      //     isChecked: false,
                      //   );

                      //   if (AddPersonScreen.isEdit) {
                      //     int index = 0;
                      //     MyApp.getPersonData();
                      //     for (int i = 0; i < hiveBox.values.length; i++) {
                      //       if (hiveBox.values.elementAt(i).id ==
                      //           AddPersonScreen.id) {
                      //         index = i;
                      //         break;
                      //       }
                      //     }

                      //     hiveBox.putAt(index, item);
                      //     MyApp.getPersonData();
                      //     //CalculatScreen.personList[AddPersonScreen.] =item;
                      //   } else {
                      //     //CalculatScreen.personList.add(item);
                      //     Get.find<CalculationController>()
                      //         .personList
                      //         .add(item);
                      //     hiveBox.add(item);
                      //   }
                      //   //!

                      //   Navigator.pop(context);
                      // },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AddPersonScreen.isEdit
                              ? 'ذخیره اطلاعات'
                              : ' ثبت اطلاعات',
                          style: MyConst.style12_16(
                            screenH,
                          ).copyWith(fontWeight: FontWeight.w700),
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

  void _submitForm() {
    FocusScope.of(context).unfocus();
    // اعتبارسنجی فرم
    if (_formKey.currentState!.validate()) {
      // اگر فرم معتبر باشد
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
          if (hiveBox.values.elementAt(i).id == AddPersonScreen.id) {
            index = i;
            break;
          }
        }

        hiveBox.putAt(index, item);
        MyApp.getPersonData();
        //CalculatScreen.personList[AddPersonScreen.] =item;
      } else {
        //CalculatScreen.personList.add(item);
        Get.find<CalculationController>().personList.add(item);
        hiveBox.add(item);
      }

      // نمایش پیام موفقیت
      _showSuccessSnackbar(
        AddPersonScreen.isEdit
            ? 'اطلاعات با موفقیت ویرایش شد'
            : 'اطلاعات با موفقیت ثبت شد',
      );

      _formKey.currentState!.reset();
      AddPersonScreen.nameController.clear();
      AddPersonScreen.numberController.clear();
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
    } else {
      // همچنین می‌توان یک اسنکبار عمومی هم نمایش داد
      _showErrorSnackbar('لطفاً اطلاعات را به درستی وارد کنید');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message, textAlign: TextAlign.right)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
