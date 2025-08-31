import 'package:get/get.dart';
import 'package:mehmani/controllers/calculation_controller.dart';

// import '../controllers/task_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => TaskController());
    Get.lazyPut(() => CalculationController());
  }
}
