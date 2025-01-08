import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shared/shared.dart';

import '../../features/auth/auth.dart';
import '../../features/parkings/views/active_parking_screen.dart';
import '../../features/parkings/views/finished_parking_screen.dart';
import '../../features/parkings/views/parking_details_screen.dart';
import '../../features/people/views/add_person_screen.dart';
import '../../features/people/views/person_details_screen.dart';
import '../../features/parkings/views/parkings_screen.dart';
import '../../features/profile/views/create_profile_screen.dart';
import '../../features/profile/views/profile_screen.dart';
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

        if (authState is AppUserSignedIn &&
            authState.user.displayName == null) {
          return "/create-profile";
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
          path: "/create-profile",
          name: AppRoute.createProfile.name,
          builder: (context, state) => CreateProfileScreen(),
        ),
        GoRoute(
          path: "/",
          name: AppRoute.home.name,
          builder: (context, state) {
            final currentTab = context.watch<BottomNavigationCubit>();
            return switch (currentTab.state) {
              BottomTab.parkings => const ParkingsScreen(),
              BottomTab.vehicles => const VehiclesScreen(),
              BottomTab.profile => const ProfileScreen(),
              BottomTab.settings => const SettingsScreen(),
            };
          },
          routes: [
            GoRoute(
              path: "parking-details",
              name: AppRoute.parkingDetails.name,
              builder: (context, state) => ParkingDetailsScreen(
                space: state.extra as ParkingSpace,
              ),
            ),
            GoRoute(
              path: "active-parking",
              name: AppRoute.activeParking.name,
              builder: (context, state) => ActiveParkingScreen(
                parking: state.extra as Parking,
              ),
            ),
            GoRoute(
              path: "finished-parking",
              name: AppRoute.finishedParking.name,
              builder: (context, state) => FinishedParkingScreen(
                parking: state.extra as Parking,
              ),
            ),
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
