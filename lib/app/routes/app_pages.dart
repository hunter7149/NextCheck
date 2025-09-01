import 'package:get/get.dart';

import '../modules/checkin/bindings/checkin_binding.dart';
import '../modules/checkin/views/checkin_view.dart';
import '../modules/createpoint/bindings/createpoint_binding.dart';
import '../modules/createpoint/views/createpoint_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/liveusers/bindings/liveusers_binding.dart';
import '../modules/liveusers/views/liveusers_view.dart';
import '../modules/loginscreen/bindings/loginscreen_binding.dart';
import '../modules/loginscreen/views/loginscreen_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.LIVEUSERS,
      page: () => const LiveusersView(),
      binding: LiveusersBinding(),
    ),
    GetPage(
      name: _Paths.CHECKIN,
      page: () => const CheckinView(),
      binding: CheckinBinding(),
    ),
    GetPage(
      name: _Paths.CREATEPOINT,
      page: () => const CreatepointView(),
      binding: CreatepointBinding(),
    ),
    GetPage(
      name: _Paths.LOGINSCREEN,
      page: () => const LoginscreenView(),
      binding: LoginscreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
