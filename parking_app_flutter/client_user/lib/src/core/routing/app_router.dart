import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shared/shared.dart';

import '../../features/auth/auth.dart';
import '../../features/people/views/add_person_screen.dart';
import '../../features/people/views/people_screen.dart';
import '../../features/people/views/person_details_screen.dart';
import '../../features/parkings/views/parkings_screen.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/vehicles/views/add_vehicle_screen.dart';
import '../../features/vehicles/views/vehicle_details_screen.dart';
import '../../features/vehicles/views/vehicles_screen.dart';
import '../cubits/app_user/app_user_cubit.dart';
import '../cubits/app_user/app_user_state.dart';
import '../cubits/navigation/bottom_navigation_cubit.dart';
import '../cubits/navigation/bottom_tab.dart';
import 'app_route.dart';

class AppRouter {
  const AppRouter._internal();

  static Future<T?> go<T>(
    BuildContext context,
    AppRoute route, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    return GoRouter.of(context).pushNamed<T>(
      route.name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
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
              BottomTab.parkings => ParkingsScreen(),
              BottomTab.vehicles => VehiclesScreen(),
              BottomTab.people => PeopleScreen(),
              BottomTab.settings => SettingsScreen(),
            };
          },
          routes: [
            GoRoute(
              path: "add-vehicle",
              name: AppRoute.addVehicle.name,
              builder: (context, state) => const AddVehicleScreen(),
            ),
            GoRoute(
              path: "vehicle-details",
              name: AppRoute.vehicleDetails.name,
              builder: (context, state) => VehicleDetailsScreen(
                vehicle: state.extra as Vehicle,
              ),
            ),
            GoRoute(
              path: "add-person",
              name: AppRoute.addPerson.name,
              builder: (context, state) => const AddPersonScreen(),
            ),
            GoRoute(
              path: "person-details",
              name: AppRoute.personDetails.name,
              builder: (context, state) => PersonDetailsScreen(
                person: state.extra as Person,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
