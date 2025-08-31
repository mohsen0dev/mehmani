import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mehmani/const.dart';
import 'package:mehmani/screen/abute.dart';
import 'package:mehmani/screen/calculat_screen.dart';
import 'package:mehmani/screen/calculat/calculator.dart';
import 'package:mehmani/screen/food/add_food.dart';
import 'package:mehmani/screen/help_screen.dart';
import 'package:mehmani/screen/models/person_model.dart';
import 'package:mehmani/screen/persons/add_person.dart';
import 'package:restart_app/restart_app.dart';
import '../abzar/bacup_restor.dart';
import '../main.dart';
import 'food/food_screen.dart';
import 'models/food_model.dart';
import 'persons/person_screen.dart';

var screenH;
var screenW;

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    int? bottomNavIndex,
  }) : super(key: key);
  static Widget body = CalculatScreen();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;
  var bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.calculate_outlined,
    Icons.group_outlined,
    Icons.restaurant_outlined,
    Icons.help_outline,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.2,
        1.0,
        curve: Curves.linearToEaseOut,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(milliseconds: 100),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlrtDlgExit();
            });
      },
      child: Scaffold(
          backgroundColor: MyConst.background,
          //! App Bar
          appBar: AppBar(
            title: Text(
              'مدیریت حساب مهمانی',
              style: MyConst.titleLarge(screenH).copyWith(
                color: MyConst.onSurface,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: MyConst.onSurface,
              ),
              onPressed: () {
                setState(() {
                  MyApp.getPersonData();
                  MyApp.getFoodData();
                });
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          endDrawer: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: screenW * 0.55,
              height: screenH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                color: MyConst.surface,
                boxShadow: [
                  BoxShadow(
                    color: MyConst.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                //! drawer widget
                child: Drawer(
                  child: Column(
                    children: <Widget>[
                      // Header
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 16,
                          bottom: 24,
                          left: 16,
                          right: 16,
                        ),
                        decoration: BoxDecoration(
                          color: MyConst.primaryContainer,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.celebration_rounded,
                              size: 48,
                              color: MyConst.onPrimaryContainer,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'مدیریت حساب مهمانی',
                              style: MyConst.titleLarge(screenH).copyWith(
                                color: MyConst.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Menu Items
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          children: <Widget>[
                            _buildDrawerItem(
                              icon: Icons.calculate_outlined,
                              title: 'محاسبه هزینه',
                              isSelected: bottomNavIndex == 0,
                              onTap: () {
                                Navigator.of(context).pop();
                                HomePage.body = CalculatScreen();
                                bottomNavIndex = 0;
                                setState(() {});
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.group_outlined,
                              title: 'تعداد خانوار',
                              isSelected: bottomNavIndex == 1,
                              onTap: () {
                                Navigator.of(context).pop();
                                HomePage.body = PersonScreen(
                                  mycontext: context,
                                );
                                bottomNavIndex = 1;
                                setState(() {});
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.restaurant_outlined,
                              title: 'اطلاعات غذا',
                              isSelected: bottomNavIndex == 2,
                              onTap: () {
                                Navigator.of(context).pop();
                                HomePage.body = const FoodScreen();
                                bottomNavIndex = 2;
                                setState(() {});
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.help_outline,
                              title: 'راهنما',
                              isSelected: bottomNavIndex == 3,
                              onTap: () {
                                Navigator.of(context).pop();
                                HomePage.body = HelpScreen();
                                bottomNavIndex = 3;
                                setState(() {});
                              },
                            ),
                            Divider(
                              color: MyConst.outlineVariant,
                              height: 32,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildDrawerItem(
                              icon: Icons.backup_rounded,
                              title: 'پشتیبان گیری',
                              onTap: () {
                                addPeople(
                                    people: people,
                                    foods: foods,
                                    context: context);
                                Navigator.of(context).pop();
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.restore_rounded,
                              title: 'بازیابی اطلاعات',
                              onTap: () async {
                                await readPeople(
                                    people: people,
                                    foods: foods,
                                    context: context);
                                Navigator.of(context).pop();
                                await Future.delayed(Duration(seconds: 3));
                                await Restart.restartApp();
                              },
                            ),
                            Divider(
                              color: MyConst.outlineVariant,
                              height: 32,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildDrawerItem(
                              icon: Icons.info_outline_rounded,
                              title: 'درباره ما',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AbutScreen()));
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.exit_to_app_rounded,
                              title: 'خروج',
                              isDestructive: true,
                              onTap: () async {
                                Navigator.pop(context);
                                return await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlrtDlgExit();
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //! floating action button
          floatingActionButton: ScaleTransition(
            scale: animation,
            child: bottomNavIndex == 3 || bottomNavIndex == 0
                ? null
                : FloatingActionButton(
                    heroTag: 'heroAdd',
                    elevation: 6,
                    backgroundColor: MyConst.primary,
                    foregroundColor: MyConst.onPrimary,
                    child: Icon(
                      bottomNavIndex == 0
                          ? Icons.equalizer_rounded
                          : Icons.add_rounded,
                      size: 28,
                    ),
                    onPressed: () {
                      if (bottomNavIndex == 1) {
                        AddPersonScreen.nameController.clear();
                        AddPersonScreen.numberController.clear();
                        AddPersonScreen.isEdit = false;

                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return AddPersonScreen(buildContext: context);
                        })));
                      } else if (bottomNavIndex == 2) {
                        AddFoodScreen.foodNameController.clear();
                        AddFoodScreen.periceController.clear();
                        AddFoodScreen.numberController.text = '';
                        AddFoodScreen.dropdownValue = 'گرم';
                        AddFoodScreen.isEdit = false;
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return AddFoodScreen();
                        })));
                      } else if (bottomNavIndex == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return Calculator();
                        })));
                      }
                    }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            backgroundColor: MyConst.surface,
            activeIndex: bottomNavIndex,
            splashColor: MyConst.primaryContainer,
            notchAndCornersAnimation: animation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 28,
            rightCornerRadius: 28,
            itemCount: iconList.length,
            height: 64,
            elevation: 8,
            shadow: BoxShadow(
              color: MyConst.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
            tabBuilder: (int index, bool isActive) {
              final color =
                  isActive ? MyConst.primary : MyConst.onSurfaceVariant;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  SizedBox(height: 4),
                  if (isActive)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: MyConst.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              );
            },
            onTap: (index) {
              if (index == 0) {
                HomePage.body = CalculatScreen();
              } else if (index == 1) {
                HomePage.body = PersonScreen(mycontext: context);
                setState(() {});
              } else if (index == 2) {
                HomePage.body = const FoodScreen();
              } else if (index == 3) {
                HomePage.body = HelpScreen();
              }

              setState(() {
                bottomNavIndex = index;
              });
            },
          ),
          body: HomePage.body),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? MyConst.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? MyConst.error
              : isSelected
                  ? MyConst.onPrimaryContainer
                  : MyConst.onSurfaceVariant,
          size: 24,
        ),
        title: Text(
          title,
          style: MyConst.bodyLarge(screenH).copyWith(
            color: isDestructive
                ? MyConst.error
                : isSelected
                    ? MyConst.onPrimaryContainer
                    : MyConst.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

//! ***** //!

  List<PersonModel> people = [];
  List<FoodModel> foods = [];
}

//!  Alert Dialog Exit
class AlrtDlgExit extends StatelessWidget {
  const AlrtDlgExit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28))),
      backgroundColor: MyConst.surface,
      surfaceTintColor: MyConst.surfaceTint,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(
        'از برنامه خارج می شوید؟',
        textDirection: TextDirection.rtl,
        style: MyConst.titleLarge(screenW < 350 ? 14 : 16).copyWith(
          color: MyConst.onSurface,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'خیر',
            style: MyConst.labelLarge(screenW < 350 ? 12 : 14).copyWith(
              color: MyConst.primary,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FilledButton(
          child: Text(
            'بله',
            style: MyConst.labelLarge(screenW < 350 ? 12 : 14).copyWith(
              color: MyConst.onPrimary,
            ),
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ],
    );
  }
}
