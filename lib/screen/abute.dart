import 'package:flutter/material.dart';

import 'package:mehmani/const.dart';
import 'package:mehmani/screen/home_page.dart';

class AbutScreen extends StatelessWidget {
  const AbutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 174, 29, 0),
                  MyConst.backgroundColor400,
                  MyConst.backgroundColor400,
                ],
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new,
                              size: screenH < 400 ? 25 : 30,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: screenW < 400 ? screenH * 0.30 : screenH * 0.28,
                      //height: 220,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double innerHeight = constraints.maxHeight;
                          double innerWidth = constraints.maxWidth;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: innerHeight * 0.60,
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screenW < 400 ? 40 : 50,
                                      ),
                                      Text(
                                        'Mohsen Faraji',
                                        style: TextStyle(
                                          color: MyConst.backgroundColor400,
                                          fontFamily: 'nunito',
                                          fontSize: screenW < 400 ? 22 : 26,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Flutter Developer',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontFamily: 'nunito',
                                                  fontSize:
                                                      screenW < 400 ? 14 : 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/profile.png',
                                    width: screenW < 400 ? 100 : 140,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: screenW < 400 ? screenH * 0.45 : screenH * 0.40,
                      width: screenW,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Contact Me',
                                  style: TextStyle(
                                    color: MyConst.backgroundColor400,
                                    fontSize: screenW < 400 ? 14 : 18,
                                    fontFamily: 'nunito',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 2.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ContactText(
                                // icon: Icons.phone,
                                text: 'مدیریت مهمانی نسخه: 1.0.0',
                                height: screenH,
                                width: screenW),
                            const SizedBox(
                              height: 15,
                            ),
                            ContactText(
                                icon: Icons.alternate_email,
                                text: 'Mohsen.faraji.dev',
                                height: screenH,
                                width: screenW),
                            const SizedBox(
                              height: 15,
                            ),
                            ContactText(
                                icon: Icons.telegram,
                                text: 'ID : @M0h3nFrji',
                                height: screenH,
                                width: screenW),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//! text
class ContactText extends StatelessWidget {
  final IconData? icon;
  final String text;
  final width;

  const ContactText({
    Key? key,
    this.icon,
    required this.text,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.08,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: MyConst.backgroundColor500,
              size: width < 400 ? 25 : 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: width < 400 ? 14 : 18,
                fontFamily: 'nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
