import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_client_auth/shared_client_auth.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'core/constants/constants.dart';
import 'core/di/dependencies.dart';
import 'core/navigation/navigation.dart';
import 'features/auth/state/auth_screen_cubit.dart';
import 'features/auth/views/sign_in_screen.dart';
import 'features/auth/views/sign_up_screen.dart';
import 'features/auth/views/unauthorized_screen.dart';
import 'features/parkings/views/parkings_screen.dart';
import 'features/spaces/views/spaces_screen.dart';
import 'features/statistics/state/active_parking_count_bloc.dart';
import 'features/statistics/state/most_popular_spaces_bloc.dart';
import 'features/statistics/state/parking_revenue_bloc.dart';
import 'features/statistics/views/statistics_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "${AppConstants.appName} - Admin",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return MainContent();
            } else if (state is AuthLoading) {
              return const CenteredProgressIndicator();
            } else if (state is AuthFailure) {
              return Center(
                child: Text("Error: ${state.message}"),
              );
            }

            final authScreenChoice = context.watch<AuthScreenCubit>().state;
            if (authScreenChoice == AuthScreenChoice.login) {
              return SignInScreen();
            } else {
              return SignUpScreen();
            }
          },
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  MainContent({super.key});

  final FirebasePersonRepository firebasePersonRepository = serviceLocator();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebasePersonRepository
          .isAdmin(FirebaseAuth.instance.currentUser?.email ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenteredProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        final isAdmin = snapshot.data as bool;
        if (!isAdmin) {
          return UnauthorizedScreen();
        }

        return NavigationRailContent();
      },
    );
  }
}

class NavigationRailContent extends StatelessWidget {
  const NavigationRailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<NavigationRailCubit>().state;

    // Load statistics
    if (selectedTab == NavigationRailTab.statistics) {
      context.read<ActiveParkingCountBloc>().add(ActiveParkingCountLoad());
      context.read<MostPopularSpacesBloc>().add(MostPopularSpacesLoad());
      context.read<ParkingRevenueBloc>().add(ParkingRevenueLoad());
    }

    return switch (selectedTab) {
      NavigationRailTab.spaces => SpacesScreen(),
      NavigationRailTab.parkings => ParkingsScreen(),
      NavigationRailTab.statistics => StatisticsScreen(),
    };
  }
}
