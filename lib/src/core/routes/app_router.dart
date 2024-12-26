import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/pages/pages.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter{
  @override
  List<AutoRoute> get routes => [
        MaterialRoute(path: '/', page: SplashRoute.page),
        MaterialRoute(path: '/login', page: LoginRoute.page),
        MaterialRoute(path: '/pin_code', page: PinCodeRoute.page),
        MaterialRoute(path: '/main', page: MainRoute.page),
        MaterialRoute(path: '/help', page: HelpRoute.page),
      ];
}
