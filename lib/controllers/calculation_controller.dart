import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:mehmani/screen/models/person_model.dart';

/// کنترلر محاسبات برای مدیریت مراحل انتخاب افراد و غذاها
class CalculationController extends GetxController {
  /// کنترلر صفحه برای انتقال بین مراحل مختلف
  final PageController pageController = PageController();

  // --- STATE VARIABLES (REACTIVE) ---
  /// مرحله فعلی در فرآیند انتخاب (0: افراد، 1: غذاها، 2: خلاصه)
  var currentStep = 0.obs;

  /// لیست افراد قابل انتخاب با قابلیت انتخاب چندتایی
  RxList<PersonModel> personList = <PersonModel>[].obs;

  /// لیست غذاهای قابل انتخاب با قابلیت انتخاب چندتایی
  late RxList<FoodModel> foodList = <FoodModel>[].obs;

  /// ذخیره آخرین مرحله‌ای که کاربر در آن بود
  var lastVisitedStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // بارگذاری داده‌ها از Hive در زمان راه‌اندازی کنترلر
    _loadDataFromHive();
    // تنظیم listener برای ذخیره آخرین مرحله
    pageController.addListener(_onPageChanged);

    // اگر مرحله خاصی باید بازیابی شود، آن را تنظیم کن
    if (Get.arguments != null && Get.arguments['restoreStep'] != null) {
      int stepToRestore = Get.arguments['restoreStep'];
      if (stepToRestore >= 0 && stepToRestore <= 2) {
        Future.delayed(Duration(milliseconds: 100), () {
          setCurrentStep(stepToRestore);
        });
      }
    }
  }

  /// بارگذاری داده‌ها از Hive
  void _loadDataFromHive() {
    try {
      // بارگذاری افراد
      Box<PersonModel> personBox = Hive.box<PersonModel>('personBox');
      personList.clear();
      for (var person in personBox.values) {
        personList.add(person);
      }

      // بارگذاری غذاها
      Box<FoodModel> foodBox = Hive.box<FoodModel>('foodBox');
      foodList.clear();
      for (var food in foodBox.values) {
        foodList.add(food);
      }
    } catch (e) {
      debugPrint('Error loading data from Hive: $e');
    }
  }

  /// بارگذاری مجدد داده‌ها از Hive
  void refreshData() {
    _loadDataFromHive();
  }

  /// ذخیره آخرین مرحله‌ای که کاربر در آن بود
  void _onPageChanged() {
    if (pageController.page != null) {
      lastVisitedStep.value = pageController.page!.round();
      currentStep.value = lastVisitedStep.value;
    }
  }

  /// بازگشت به آخرین مرحله‌ای که کاربر در آن بود
  void restoreLastVisitedStep() {
    if (lastVisitedStep.value != currentStep.value) {
      currentStep.value = lastVisitedStep.value;
      pageController.animateToPage(
        lastVisitedStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  /// تنظیم مرحله فعلی بدون انیمیشن (برای بازگشت از صفحات دیگر)
  void setCurrentStep(int step) {
    if (step >= 0 && step <= 2) {
      currentStep.value = step;
      lastVisitedStep.value = step;
      pageController.jumpToPage(step);
    }
  }

  /// تنظیم مرحله با انیمیشن
  void setCurrentStepWithAnimation(int step) {
    if (step >= 0 && step <= 2) {
      currentStep.value = step;
      lastVisitedStep.value = step;
      pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // --- GETTERS (COMPUTED PROPERTIES) ---
  /// تعداد افراد انتخاب شده
  int get selectedPeopleCount => personList.where((p) => p.isChecked).length;

  /// مجموع تعداد مهمانان از تمام خانواده‌های انتخاب شده
  int get totalGuests => personList
      .where((p) => p.isChecked)
      .fold(0, (sum, person) => sum + int.parse(person.conter));

  /// تعداد غذاهای انتخاب شده
  int get selectedFoodsCount => foodList.where((f) => f.isChecked).length;

  /// بررسی فعال بودن دکمه بعدی بر اساس مرحله فعلی
  bool get isNextButtonEnabled {
    if (currentStep.value == 0) {
      return selectedPeopleCount > 0; // Must select at least one family
    }
    if (currentStep.value == 1) {
      return selectedFoodsCount > 0; // Must select at least one food
    }
    return true; // Always enabled for the summary step
  }

  // --- METHODS (USER ACTIONS) ---
  /// انتقال به مرحله بعدی با انیمیشن
  void goToNextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      // Animate to the next page in the PageView
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  /// بازگشت به مرحله قبلی با انیمیشن
  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      // Animate to the previous page in the PageView
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  /// تغییر وضعیت انتخاب یک آیتم (انتخاب یا عدم انتخاب)
  void toggleSelection(int index, bool isPersonList) {
    if (isPersonList) {
      personList[index].isChecked = !personList[index].isChecked;
      personList.refresh(); // Notify listeners to rebuild the UI
    } else {
      foodList[index].isChecked = !foodList[index].isChecked;
      foodList.refresh();
    }
  }

  /// انتخاب یا عدم انتخاب تمام آیتم‌های یک لیست
  void toggleAll(bool select, bool isPersonList) {
    if (isPersonList) {
      for (var person in personList) {
        person.isChecked = select;
      }
      personList.refresh();
    } else {
      for (var food in foodList) {
        food.isChecked = select;
      }
      foodList.refresh();
    }
  }

  /// پاکسازی کنترلر صفحه هنگام حذف کنترلر از حافظه
  @override
  void onClose() {
    pageController.removeListener(_onPageChanged);
    pageController.dispose();
    super.onClose();
  }
}
