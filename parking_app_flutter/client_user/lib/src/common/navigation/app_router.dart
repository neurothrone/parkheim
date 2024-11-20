import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import 'app_route.dart';

class AppRouter {
  const AppRouter._internal();

  static Future<T?> go<T>(
    BuildContext context,
    AppRoute route, {
    Map<String, String> pathParameters = const {},
  }) {
    return GoRouter.of(context).pushNamed<T>(
      route.name,
      pathParameters: pathParameters,
    );
  }

  static void pop(BuildContext context) => GoRouter.of(context).pop();

  static GoRouter config = GoRouter(
    initialLocation: "/auth",
    routes: [
      GoRoute(
        path: "/auth",
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: "register",
            name: AppRoute.register.name,
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      ),
    ],
  );
}
