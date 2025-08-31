import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehmani/const.dart';
import 'package:mehmani/controllers/calculation_controller.dart';

// The screen is now a StatelessWidget because all state is managed by CalculationController.
class CalculatScreen extends StatelessWidget {
  CalculatScreen({Key? key}) : super(key: key);

  // Initialize the controller. Get.put() creates a new instance of the controller.
  final CalculationController controller = Get.put(CalculationController());

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyConst.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              // Header section (Stepper and titles)
              _buildHeader(screenH),

              // PageView for the main content, allowing swipe gestures
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  // Update the controller's currentStep when the user swipes
                  onPageChanged: (index) =>
                      controller.currentStep.value = index,
                  children: [
                    _buildSelectionList(true, screenH), // Step 0: Families
                    _buildSelectionList(false, screenH), // Step 1: Foods
                    _buildSummary(screenH), // Step 2: Summary
                  ],
                ),
              ),

              // Bottom navigation buttons (Previous/Next)
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // --- BUILDER WIDGETS ---

  Widget _buildHeader(double screenH) {
    // Obx widget automatically rebuilds when any of its reactive variables change.
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: MyConst.primaryContainer,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Stepper UI
              Row(
                children: [
                  _buildProgressStep(
                      0, 'خانواده', controller.currentStep.value >= 0),
                  Expanded(
                      child:
                          _buildProgressLine(controller.currentStep.value > 0)),
                  _buildProgressStep(
                      1, 'غذا', controller.currentStep.value >= 1),
                  Expanded(
                      child:
                          _buildProgressLine(controller.currentStep.value > 1)),
                  _buildProgressStep(
                      2, 'محاسبه', controller.currentStep.value >= 2),
                ],
              ),
              const SizedBox(height: 16),
              // AnimatedSwitcher provides a smooth transition for the title text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.5), end: Offset.zero)
                            .animate(animation),
                        child: child),
                  );
                },
                child: Text(
                  _getStepTitle(controller.currentStep.value),
                  // Using ValueKey ensures AnimatedSwitcher knows the widget has changed
                  key: ValueKey<int>(controller.currentStep.value),
                  style: MyConst.titleLarge(screenH).copyWith(
                    color: MyConst.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getStepDescription(controller.currentStep.value),
                style: MyConst.bodyLarge(screenH).copyWith(
                  color: MyConst.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ));
  }

  // A single, reusable widget for both person and food selection lists.
  Widget _buildSelectionList(bool isPersonList, double screenH) {
    final list = isPersonList ? controller.personList : controller.foodList;

    return Obx(
      () => list.isEmpty
          ? _buildEmptyState(
              icon: isPersonList
                  ? Icons.group_off_outlined
                  : Icons.restaurant_menu_outlined,
              title: isPersonList ? 'خانواده‌ای ثبت نشده' : 'غذایی ثبت نشده',
              subtitle: 'لطفا ابتدا از صفحه اصلی موارد را اضافه کنید',
              screenH: screenH,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              controller.toggleAll(true, isPersonList),
                          icon: const Icon(Icons.select_all_rounded, size: 18),
                          label: const Text('انتخاب همه'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              controller.toggleAll(false, isPersonList),
                          icon: const Icon(Icons.deselect_rounded, size: 18),
                          label: const Text('لغو همه'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final dynamic item = list[index];
                      return Card(
                        elevation: item.isChecked ? 2 : 0.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: item.isChecked
                                ? MyConst.primary.withOpacity(0.8)
                                : Colors.grey.shade300,
                            width: item.isChecked ? 1.5 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () =>
                              controller.toggleSelection(index, isPersonList),
                          borderRadius: BorderRadius.circular(16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            leading: IgnorePointer(
                              child: Checkbox(
                                value: item.isChecked,
                                onChanged:
                                    (val) {}, // Logic is handled by InkWell's onTap
                                activeColor: MyConst.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                            title: Text(item.title,
                                style: TextStyle(
                                    fontWeight: item.isChecked
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            subtitle: Text(
                              isPersonList
                                  ? '${(item).conter} نفر'
                                  : '${(item).amount} ${(item).vahed}',
                            ),
                            trailing: isPersonList
                                ? null
                                : Text(
                                    '${(item).fi} تومان',
                                    style: TextStyle(
                                        color: MyConst.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummary(double screenH) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      // Obx ensures this part of the UI updates whenever selected counts change.
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSummaryCard(
                  icon: Icons.group_rounded,
                  color: MyConst.primary,
                  label: 'خانواده‌های انتخاب شده',
                  value: '${controller.selectedPeopleCount} خانواده',
                  subValue: 'مجموعا ${controller.totalGuests} نفر',
                  screenH: screenH),
              const SizedBox(height: 20),
              _buildSummaryCard(
                  icon: Icons.restaurant_menu_rounded,
                  color: MyConst.secondary,
                  label: 'غذاهای انتخاب شده',
                  value: '${controller.selectedFoodsCount} نوع غذا',
                  screenH: screenH),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyConst.tertiaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: MyConst.onTertiaryContainer),
                    const SizedBox(width: 12),
                    Text('آماده برای محاسبه نهایی',
                        style: TextStyle(
                            color: MyConst.onTertiaryContainer,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Spacer(),
            ],
          )),
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Show "Previous" button only if not on the first step
              if (controller.currentStep.value > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.goToPreviousStep,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('قبلی'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (controller.currentStep.value > 0) const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  // Button is disabled if isNextButtonEnabled is false
                  onPressed: controller.isNextButtonEnabled
                      ? controller.goToNextStep
                      : null,
                  icon: Icon(controller.currentStep.value == 2
                      ? Icons.calculate_rounded
                      : Icons.arrow_forward_rounded),
                  label: Text(controller.currentStep.value == 2
                      ? 'محاسبه کن'
                      : 'مرحله بعد'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: MyConst.primary,
                    foregroundColor: MyConst.onPrimary,
                    // Style for the disabled state
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // --- HELPER WIDGETS AND METHODS (UNCHANGED LOGIC) ---

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 36 : 32,
          height: isActive ? 36 : 32,
          decoration: BoxDecoration(
            color: isActive
                ? MyConst.onPrimaryContainer
                : MyConst.onPrimaryContainer.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStepIcon(step),
            color: isActive
                ? MyConst.primaryContainer
                : MyConst.onPrimaryContainer.withOpacity(0.5),
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? MyConst.onPrimaryContainer
                : MyConst.onPrimaryContainer.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? MyConst.onPrimaryContainer
            : MyConst.onPrimaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required IconData icon,
      required Color color,
      required String label,
      required String value,
      String? subValue,
      required double screenH}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: MyConst.bodyLarge(screenH)
                        .copyWith(color: MyConst.onSurfaceVariant)),
                Text(value,
                    style: MyConst.titleLarge(screenH).copyWith(
                        fontWeight: FontWeight.bold, color: MyConst.onSurface)),
                if (subValue != null) ...[
                  const SizedBox(height: 2),
                  Text(subValue,
                      style: MyConst.bodyLarge(screenH)
                          .copyWith(color: MyConst.onSurfaceVariant)),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      {required IconData icon,
      required String title,
      required String subtitle,
      required double screenH}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 64, color: MyConst.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(title,
              style: MyConst.titleLarge(screenH).copyWith(
                  color: MyConst.onSurface, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: MyConst.bodyLarge(screenH)
                .copyWith(color: MyConst.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.group_rounded;
      case 1:
        return Icons.restaurant_rounded;
      case 2:
        return Icons.calculate_rounded;
      default:
        return Icons.circle;
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'انتخاب خانواده‌ها';
      case 1:
        return 'انتخاب غذاها';
      case 2:
        return 'خلاصه و تایید نهایی';
      default:
        return '';
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'خانواده‌هایی که دعوت شده‌اند را انتخاب کنید';
      case 1:
        return 'غذاهایی که سرو می‌شود را انتخاب کنید';
      case 2:
        return 'بررسی نهایی پیش از محاسبه هزینه‌ها';
      default:
        return '';
    }
  }
}
