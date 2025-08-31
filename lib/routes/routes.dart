import 'package:get/get.dart';
import '../screen/calculat_screen.dart';
import '../screen/home_page.dart';

class Routs {
  static List<GetPage> get Pages => [
        GetPage(name: '/HomePage', page: () => HomePage()),
        GetPage(name: '/CalculatScreen', page: () => CalculatScreen()),
      ];
}
