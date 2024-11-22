import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/navigation/bottom_navigation_cubit.dart';
import '../cubits/navigation/bottom_tab.dart';
import '../../features/auth/auth.dart';
import '../cubits/app_user/app_user_cubit.dart';
import '../cubits/app_user/app_user_state.dart';
import '../../features/parkings/parkings_screen.dart';
import '../../features/people/people_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/spaces/spaces_screen.dart';
import '../../features/vehicles/vehicles_screen.dart';
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

  static GoRouter config(BuildContext context) {
    final appUser = context.watch<AppUserCubit>();

    return GoRouter(
      initialLocation: "/",
      redirect: (context, state) {
        final authState = appUser.state;
        final isAuthPath = state.fullPath?.startsWith("/auth") ?? false;

        if (authState is AppUserInitial && !isAuthPath) {
          return "/auth";
        }

        return null;
      },
      routes: [
        GoRoute(
          path: "/auth",
          name: AppRoute.login.name,
          builder: (context, state) => const SignInScreen(),
          routes: [
            GoRoute(
              path: "register",
              name: AppRoute.register.name,
              builder: (context, state) => const SignUpScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "/",
          name: AppRoute.home.name,
          builder: (context, state) {
            final currentTab = context.watch<BottomNavigationCubit>();
            return switch (currentTab.state) {
              BottomTab.people => PeopleScreen(),
              BottomTab.vehicles => VehiclesScreen(),
              BottomTab.spaces => SpacesScreen(),
              BottomTab.parkings => ParkingsScreen(),
              BottomTab.settings => SettingsScreen(),
            };
          },
        ),
      ],
    );
  }
}
