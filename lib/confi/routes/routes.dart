import 'package:currencyapp/confi/routes/routesname.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../view/ForgetPassword.dart';
import '../../view/HomePage.dart';
import '../../view/Login.dart';
import '../../view/SignUp.dart';
import '../../view/splashscreen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _routeNavigatorState =
  GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
      navigatorKey: _routeNavigatorState,
      initialLocation: RoutesName.splash_route,
      routes: <RouteBase>[
        GoRoute(
          path: RoutesName.splash_route,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen();
          },
        ),
        GoRoute(
          path: RoutesName.home_route,
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: RoutesName.login_route,
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: RoutesName.signup_route,
          builder: (BuildContext context, GoRouterState state) {
            return SignupPage();
          },
        ),
        GoRoute(
          path: RoutesName.forgetpass,
          builder: (BuildContext context, GoRouterState state) {
            return ForgotPasswordPage();
          },
        ),
      ]);
}
