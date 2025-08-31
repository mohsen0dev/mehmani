import 'package:flutter/material.dart';
import 'package:mehmani/screen/abute.dart';
import 'package:mehmani/screen/home_page.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenW = MediaQuery.of(context).size.width.toInt();

    //final screenH = MediaQuery.of(context).size.height.toInt();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 22,
                ),
                Text(
                  'راهنمای استفاده از برنامه',
                  style: TextStyle(
                      fontSize: screenW < 350 ? 16 : 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                myText(
                  'در قدم اول از قسمت تعداد خانوار نام خانواده و تعداد آن را اضافه کنید. مثلا خانواد یک تعداد نفرات4 - خانواده دو تعداد نفرات3',
                  screenW,
                ),
                SizedBox(height: 20),
                myText(
                  'در مرحله دوم از قسمت اطلاعات غذا، وزن و قیمت  غذای مورد نظر برای یک نفر را وارد کنید. مثلا برنج مورد نیاز یک نفر 300 گرم و قیمت 300 گرم برنج 30 هزار تومان\nتوجه داشته باشید وزن و قیمت هر ماده غذایی بر اساس یک نفر وارد شود',
                  screenW,
                ),
                SizedBox(height: 20),
                myText(
                  'در صفحه محاسبات، فقط کافیت خانواده های مورد نظر برای مهمانی را از لیستی که قبلا وارد کردید انتخاب کنید تا برنامه تعداد نفرات و مقدار و هزینه مورد نیاز انواع غذا هایی که وارد کردید را محاسبه کند',
                  screenW,
                ),
                SizedBox(height: 20),
                myText(
                  'در صورتی که برای استفاده از برنامه با مشکلی مواجه شدید لطفا با ما در ارتباط باشید',
                  screenW,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'ارتباط با ما',
                    style: TextStyle(fontSize: screenW < 350 ? 12 : 16),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AbutScreen()));
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text myText(String text, double screenW) {
    return Text(text,
        style: TextStyle(
          fontSize: screenW < 350 ? 12 : 16,
        ));
  }
}
