import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/bindings/binding.dart';
import 'package:mehmani/const.dart';
import 'package:mehmani/controllers/calculation_controller.dart';
import 'package:mehmani/routes/routes.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:mehmani/screen/models/person_model.dart';
// import 'controllers/task_controller.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PersonModelAdapter());
  Hive.registerAdapter(FoodModelAdapter());

  await Hive.openBox<FoodModel>('foodBox');
  await Hive.openBox<PersonModel>('personBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static getPersonData() {
    Get.find<CalculationController>().personList.clear();
    Box<PersonModel> hiveBox = Hive.box<PersonModel>('personBox');
    for (var element in hiveBox.values) {
      Get.find<CalculationController>().personList.add(element);
    }
  }

  static getFoodData() {
    Get.find<CalculationController>().foodList.clear();
    Box<FoodModel> hiveBox = Hive.box<FoodModel>('foodBox');
    for (var element in hiveBox.values) {
      Get.find<CalculationController>().foodList.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      initialBinding: MyBindings(),
      getPages: Routs.Pages,
      initialRoute: '/HomePage',
      title: 'مدیریت مهمانی',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'vazir',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // Material 3 primary color
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 2,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1C1B1F),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1B1F),
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Color(0xFFFFFBFE),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: MyConst.backgroundColor200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 3,
          shape: CircleBorder(),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 8,
          backgroundColor: Color(0xFFFFFBFE),
          selectedItemColor: Color(0xFF6750A4),
          unselectedItemColor: Color(0xFF49454F),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFFFFFBFE),
          elevation: 1,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minLeadingWidth: 40,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: MyConst.backgroundColor200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
