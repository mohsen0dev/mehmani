//! جدا کننده 3 رقم اعداد

extension NumberSFormat on String {
  String to3ragham() {
    // اعداد غیر از ارقام رو حذف کن
    final cleanedString = replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedString.isEmpty) {
      return '';
    }

    // از یک Regular Expression برای اضافه کردن کاما استفاده کن
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

    return cleanedString.replaceAllMapped(regExp, (Match m) => '${m[1]},');
  }
}
