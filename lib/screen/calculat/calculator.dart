import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/home_page.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:mehmani/screen/models/person_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../abzar/seRagham.dart';
import '../../const.dart';

class Calculator extends StatefulWidget {
  Calculator({Key? key}) : super(key: key);
  static TextEditingController giftText = TextEditingController();

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int sumNafarat = 0;
  int sumKhanevar = 0;
  int sumHazine = 0;

  String myLable = '';

  @override
  void initState() {
    Calculator.giftText.text = MyConst.gift;

    setState(() {
      myLable = MyConst.gift.toWord();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var getPerson = Get.find<CalculationController>().personList;
    var getFood = Get.find<CalculationController>().foodList;
    setDataPerson(getPerson);
    setDataFood(getFood);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('محاسبه تعداد و هزینه '),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 25, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text('  : میانگین هدیه هر خانواده',
                          style: MyConst.style12_16(screenH)),
                      Expanded(
                          child: Container(
                        height: 50,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            textAlign: TextAlign.left,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ThousandsSeparatorInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: '${MyConst.gift.toWord()} تومان',
                              labelStyle: MyConst.style12_16(screenH).copyWith(
                                color: Colors.black54,
                              ),
                              // prefixText: 'تومان',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 1),
                            ),
                            controller: Calculator.giftText,
                            onChanged: (v) {
                              MyConst.gift = v;
                              setState(() {});
                            },
                            onSubmitted: (v) {
                              MyConst.gift = v;
                              setDataPerson(getPerson);
                              setState(() {});
                            },
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MyConst.primaryContainer,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextWidget(
                            text: 'تعداد خانوار دعوت شده :',
                            fi: sumKhanevar.toString(),
                            text2: ' خانوار'),
                        TextWidget(
                            text: 'تعداد نفرات دعوت شده :',
                            fi: sumNafarat.toString().seRagham(),
                            text2: ' نفر'),
                        TextWidget(
                          text: 'براورد کل هدیه : ',
                          fi: '${getPerson.where((element) {
                                    return element.isChecked == true;
                                  }).length * int.parse(MyConst.gift.replaceAll(',', ''))}'
                              .toString()
                              .seRagham(),
                          text2: ' تومان',
                        ),
                        TextWidget(
                            text: 'براورد کل هزینه : ',
                            fi: sumHazine.toString().seRagham(),
                            text2: ' تومان'),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(' : لیست اقلام غذایی انتخاب شده',
                              style: MyConst.style12_16(screenH)),
                        ),
                        for (var i in getFood)
                          if (i.isChecked == true)
                            TextWidget(
                                text:
                                    '${i.title} ${(int.parse(i.amount) * sumNafarat).toString().seRagham()} ${i.vahed} ',
                                fi: '${(int.parse(i.fi) * sumNafarat).toString().seRagham()}',
                                text2: ' تومان'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void setDataPerson(RxList<PersonModel> getPerson) {
    sumKhanevar = 0;
    sumNafarat = 0;
    for (var i in getPerson)
      if (i.isChecked) {
        sumNafarat += num.parse(i.conter).toInt();
        sumKhanevar += 1;
      }
  }

  void setDataFood(RxList<FoodModel> getFood) {
    sumHazine = 0;
    for (var i in getFood)
      if (i.isChecked) {
        sumHazine += num.parse(i.fi).toInt() * sumNafarat;
      }
  }
}

class TextWidget extends StatelessWidget {
  final String? text;
  final String? fi;
  final String? text2;

  TextWidget({
    Key? key,
    required this.text,
    this.fi,
    this.text2,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                text: '     $text ',
                style:
                    MyConst.style12_16(screenH).copyWith(color: Colors.black87),
                children: [
                  TextSpan(
                    text: fi,
                    style: MyConst.style16_18(screenH).copyWith(
                        color: MyConst.backgroundColor500,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: '$text2  ',
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: MyConst.backgroundColor400,
            ),
          ],
        ));
  }
}
