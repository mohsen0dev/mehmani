import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehmani/controllers/task_controller.dart';
import 'package:mehmani/screen/calculat/calculator.dart';
import 'package:mehmani/screen/models/food_model.dart';
import 'package:mehmani/screen/models/person_model.dart';

class CalculationController extends GetxController {
  // --- DEPENDENCIES ---
  // A single instance of TaskController to get initial data
  // final TaskController _taskController = Get.find<TaskController>();

  // --- UI CONTROLLERS ---
  // PageController for smooth step transitions between pages
  final PageController pageController = PageController();

  // --- STATE VARIABLES (REACTIVE) ---
  // .obs makes the variable observable, so UI widgets can react to its changes
  var currentStep = 0.obs;

  // These lists hold the state of our selections
  RxList<PersonModel> personList = <PersonModel>[].obs;
  late RxList<FoodModel> foodList = <FoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  // --- GETTERS (COMPUTED PROPERTIES) ---
  // Getters provide calculated values based on the state. They are efficient
  // because they are recalculated automatically only when a dependency changes.

  int get selectedPeopleCount => personList.where((p) => p.isChecked).length;

  int get totalGuests => personList
      .where((p) => p.isChecked)
      .fold(0, (sum, person) => sum + int.parse(person.conter));

  int get selectedFoodsCount => foodList.where((f) => f.isChecked).length;

  // This getter contains the logic to enable/disable the "Next" button
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
  // These methods are called from the UI to change the state.

  void goToNextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      // Animate to the next page in the PageView
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Final step: Navigate to the Calculator screen
      Get.to(() => Calculator());
    }
  }

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

  // Toggles the 'isChecked' status of a single item
  void toggleSelection(int index, bool isPersonList) {
    if (isPersonList) {
      personList[index].isChecked = !personList[index].isChecked;
      personList.refresh(); // Notify listeners to rebuild the UI
    } else {
      foodList[index].isChecked = !foodList[index].isChecked;
      foodList.refresh();
    }
  }

  // Selects or deselects all items in a list
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

  // Clean up the PageController when the controller is removed from memory
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
