import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:mehmani/const.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/screen/abute.dart';
import 'package:mehmani/screen/calculat_screen.dart';
import 'package:mehmani/screen/calculat/calculator.dart';
import 'package:mehmani/screen/food/add_food.dart';
import 'package:mehmani/screen/help_screen.dart';
import 'package:mehmani/screen/models/person_model.dart';
import 'package:mehmani/screen/persons/add_person.dart';
import 'package:restart_app/restart_app.dart';
import '../abzar/bacup_restor.dart';
import 'food/food_screen.dart';
import 'models/food_model.dart';
import 'persons/person_screen.dart';

var screenH;
var screenW;

/// متغیر global برای ذخیره مرحله فعلی CalculatScreen
int globalCalculatStep = 0;

class HomePage extends StatefulWidget {
  HomePage({Key? key, int? bottomNavIndex}) : super(key: key);
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

  /// ذخیره آخرین صفحه‌ای که کاربر در آن بود
  var lastVisitedPage = 0;

  /// ذخیره آخرین مرحله در CalculatScreen
  var lastCalculatStep = 0;

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
      curve: Interval(0.2, 1.0, curve: Curves.linearToEaseOut),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve);

    Future.delayed(
      Duration(milliseconds: 100),
      () => _animationController.forward(),
    );
  }

  /// مدیریت دکمه بک گوشی
  Future<bool> _handleBackButton() async {
    double pageNumber;
    final pagController = Get.find<CalculationController>().pageController;
    if (pagController.hasClients) {
      pageNumber = pagController.page!;
    } else {
      pageNumber = 0.0;
    }

    // اگر در صفحه CalculatScreen هستیم
    if (bottomNavIndex == 0) {
      // اگر در مرحله اول نیستیم، به مرحله قبل برو
      if (pageNumber > 0) {
        Get.find<CalculationController>().goToPreviousStep();
        return false; // از خروج جلوگیری کن
      } else {
        // اگر در مرحله اول هستیم، دیالوگ خروج را نشان بده
        final bool shouldExit =
            await showDialog(
              context: context,
              builder: (context) {
                return AlrtDlgExit();
              },
            ) ??
            false;
        return shouldExit;
      }
    } else {
      // اگر در صفحات دیگر هستیم، به CalculatScreen برگرد
      setState(() {
        bottomNavIndex = 0;
        HomePage.body = CalculatScreen();
        // بازگشت به آخرین مرحله‌ای که کاربر در آن بود
        if (globalCalculatStep > 0) {
          Future.delayed(Duration(milliseconds: 300), () {
            try {
              final controller = Get.find<CalculationController>();

              controller.setCurrentStep(globalCalculatStep);
            } catch (e) {
              debugPrint('Error restoring step from back button: $e');
            }
          });
        }
      });
      return false; // از خروج جلوگیری کن
    }
  }

  /// تغییر صفحه با ذخیره وضعیت فعلی
  void _changePage(int newIndex) {
    // ذخیره وضعیت فعلی
    if (bottomNavIndex == 0) {
      // اگر در CalculatScreen هستیم، مرحله فعلی را ذخیره کن
      try {
        final controller = Get.find<CalculationController>();
        lastCalculatStep = controller.currentStep.value;
        globalCalculatStep = lastCalculatStep; // ذخیره در متغیر global
      } catch (e) {
        debugPrint('Error getting current step: $e');
      }
    }

    // ذخیره آخرین صفحه بازدید شده
    lastVisitedPage = bottomNavIndex;

    // تغییر صفحه
    if (newIndex == 0) {
      HomePage.body = CalculatScreen();
      // بعد از ایجاد CalculatScreen، مرحله ذخیره شده را بازیابی کن
      if (globalCalculatStep > 0) {
        Future.delayed(Duration(milliseconds: 300), () {
          try {
            final controller = Get.find<CalculationController>();
            controller.setCurrentStep(globalCalculatStep);
          } catch (e) {
            debugPrint('Error restoring step: $e');
          }
        });
      }
    } else if (newIndex == 1) {
      HomePage.body = PersonScreen(mycontext: context);
    } else if (newIndex == 2) {
      HomePage.body = const FoodScreen();
    } else if (newIndex == 3) {
      HomePage.body = HelpScreen();
    }

    setState(() {
      bottomNavIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldExit = await _handleBackButton();
        if (shouldExit) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: MyConst.background,
        //! App Bar
        appBar: AppBar(
          title: Text(
            'مدیریت حساب مهمانی',
            style: MyConst.style16_18(
              screenH,
            ).copyWith(color: MyConst.onSurface),
          ),
          leading: IconButton(
            icon: Icon(Icons.refresh_rounded, color: MyConst.onSurface),
            onPressed: () {
              setState(() {
                // استفاده از متد جدید کنترلر برای بارگذاری مجدد داده‌ها
                Get.find<CalculationController>().refreshData();
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
            width: screenW * 0.60,
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
                          style: MyConst.style16_18(screenH).copyWith(
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
                      padding: EdgeInsets.symmetric(vertical: 6),
                      children: <Widget>[
                        _buildDrawerItem(
                          icon: Icons.calculate_outlined,
                          title: 'محاسبه هزینه',
                          isSelected: bottomNavIndex == 0,
                          onTap: () {
                            Navigator.of(context).pop();
                            _changePage(0);
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.group_outlined,
                          title: 'تعداد خانوار',
                          isSelected: bottomNavIndex == 1,
                          onTap: () {
                            Navigator.of(context).pop();
                            _changePage(1);
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.restaurant_outlined,
                          title: 'اطلاعات غذا',
                          isSelected: bottomNavIndex == 2,
                          onTap: () {
                            Navigator.of(context).pop();
                            _changePage(2);
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.help_outline,
                          title: 'راهنما',
                          isSelected: bottomNavIndex == 3,
                          onTap: () {
                            Navigator.of(context).pop();
                            _changePage(3);
                          },
                        ),
                        Divider(
                          color: MyConst.outlineVariant,
                          height: 16,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildDrawerItem(
                          icon: Icons.backup_outlined,
                          title: 'پشتیبان گیری',
                          onTap: () {
                            addPeople(
                              people: people,
                              foods: foods,
                              context: context,
                            );
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
                              context: context,
                            );
                            Navigator.of(context).pop();
                            await Future.delayed(Duration(seconds: 3));
                            await Restart.restartApp();
                          },
                        ),
                        Divider(
                          color: MyConst.outlineVariant,
                          height: 16,
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
                                builder: (context) => AbutScreen(),
                              ),
                            );
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
                              },
                            );
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return AddPersonScreen(buildContext: context);
                          }),
                        ),
                      );
                    } else if (bottomNavIndex == 2) {
                      AddFoodScreen.foodNameController.clear();
                      AddFoodScreen.periceController.clear();
                      AddFoodScreen.numberController.text = '';
                      AddFoodScreen.dropdownValue = 'گرم';
                      AddFoodScreen.isEdit = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return AddFoodScreen();
                          }),
                        ),
                      );
                    } else if (bottomNavIndex == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return Calculator();
                          }),
                        ),
                      );
                    }
                  },
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
            color: MyConst.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? MyConst.primary : MyConst.onSurfaceVariant;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconList[index], size: 24, color: color),
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
            _changePage(index);
          },
        ),
        body: HomePage.body,
      ),
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
      // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      height: 52,
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
          // size: 24,
        ),
        title: Text(
          title,
          style: MyConst.labelLarge(screenH).copyWith(
            color: isDestructive
                ? MyConst.error
                : isSelected
                ? MyConst.onPrimaryContainer
                : MyConst.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  //! ***** //!

  List<PersonModel> people = [];
  List<FoodModel> foods = [];
}

//!  Alert Dialog Exit
class AlrtDlgExit extends StatelessWidget {
  const AlrtDlgExit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      backgroundColor: MyConst.surface,
      surfaceTintColor: MyConst.surfaceTint,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(
        'از برنامه خارج می شوید؟',
        textDirection: TextDirection.rtl,
        style: MyConst.style16_18(screenW).copyWith(color: MyConst.onSurface),
      ),
      actions: <Widget>[
        OutlinedButton(
          child: Text(
            'خیر',
            style: MyConst.labelLarge(screenW).copyWith(color: MyConst.primary),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FilledButton(
          child: Text(
            'بله',
            style: MyConst.bodyLarge(
              screenW,
            ).copyWith(color: MyConst.onPrimary),
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ],
    );
  }
}
