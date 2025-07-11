import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.blackColor,
      textColor: AppColors.whiteColor,
      fontSize: 16.0,
    );
  }
}
