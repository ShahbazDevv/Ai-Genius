String formatPkr(int amount) {
  final str = amount.toString();
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final formatted = str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  return 'PKR $formatted';
}

class AppUtils {
  AppUtils._();

  static String formatPkr(int amount) => formatPkr(amount);
}
