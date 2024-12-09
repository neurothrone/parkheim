import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/core/cubits/navigation/bottom_navigation_cubit.dart';
import 'src/core/di/dependencies.dart';
import 'src/core/cubits/app_user/app_user_cubit.dart';
import 'src/features/auth/bloc/auth_bloc.dart';
import 'src/features/parkings/state/active_parkings/active_parkings_bloc.dart';
import 'src/features/parkings/state/available_spaces/available_spaces_bloc.dart';
import 'src/features/settings/state/dark_mode_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        // !: Cubits
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BottomNavigationCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<DarkModeCubit>(),
        ),
        // !: Blocs
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ActiveParkingsBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AvailableSpacesBloc>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
