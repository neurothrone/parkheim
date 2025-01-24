import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/active_parking_count_bloc.dart';

class ActiveParkingsCountListTile extends StatelessWidget {
  const ActiveParkingsCountListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveParkingCountBloc, ActiveParkingCountState>(
      builder: (context, state) {
        if (state is ActiveParkingCountLoaded) {
          return ListTile(
            title: Text(
              "Active parkings:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Text(
              state.activeParkingCount.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        }

        if (state is ActiveParkingCountFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
