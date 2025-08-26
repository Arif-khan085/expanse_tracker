import 'package:expense_tracker/res/routes/routes_named.dart';
import 'package:expense_tracker/view/addExpanse/expanses.dart';
import 'package:expense_tracker/view/homescreen/homescreen.dart';
import 'package:expense_tracker/view/profile/profile.dart';
import 'package:get/get.dart';

import '../../view/login/login_view.dart';
import '../../view/signin/signin.dart';
import '../../view/splash_screen.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RoutesName.login,
      page: () => SignIn(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.loginView,
      page: () => LoginView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.homeScreen,
      page: () => HomeScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RoutesName.expense,
      page: () => Expense(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => Profile(),
      transition: Transition.leftToRight,
    ),

  ];
}
