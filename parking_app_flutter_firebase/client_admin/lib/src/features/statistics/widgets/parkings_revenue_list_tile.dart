import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_widgets/shared_widgets.dart';

import '../state/parking_revenue_bloc.dart';

class ParkingsRevenueListTile extends StatelessWidget {
  const ParkingsRevenueListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingRevenueBloc, ParkingRevenueState>(
      builder: (context, state) {
        if (state is ParkingRevenueLoaded) {
          return ListTile(
            title: Text(
              "Total revenue:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Text(
              "\$${state.revenue}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        }

        if (state is ParkingRevenueFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return CenteredProgressIndicator();
      },
    );
  }
}
