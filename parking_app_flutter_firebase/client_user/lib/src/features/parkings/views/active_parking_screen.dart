import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../../vehicles/widgets/vehicle_details.dart';
import '../state/active_parkings/active_parkings_bloc.dart';
import '../widgets/parking_countdown.dart';
import '../widgets/parking_space_details.dart';

// class ActiveParkingScreen extends StatelessWidget {
//   const ActiveParkingScreen({
//     super.key,
//     required this.parking,
//   });
//
//   final Parking parking;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ActiveParkingsBloc, ActiveParkingsState>(
//       listener: (context, state) {
//         if (state is ActiveParkingsFailure) {
//           SnackBarService.showError(context, "Error: ${state.message}");
//         } else if (state is ActiveParkingExtended) {
//           SnackBarService.showSuccess(context, "Parking extended successfully");
//         } else if (state is ActiveParkingEnded) {
//           AppRouter.pop(context);
//           SnackBarService.showSuccess(context, "Parking ended successfully");
//         }
//       },
//       child: CustomScaffold(
//         title: "Parking",
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Hero(
//                 tag: parking.id,
//                 child: CustomCircleAvatar(icon: Icons.local_parking_rounded),
//               ),
//               const SizedBox(height: 20.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Started parking:",
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   Text(
//                     parking.startTime.formatted,
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//               Divider(),
//               const SizedBox(height: 10.0),
//               if (parking.parkingSpace != null) ...[
//                 ParkingSpaceDetails(space: parking.parkingSpace!),
//                 Divider(),
//                 const SizedBox(height: 10.0),
//               ],
//               if (parking.vehicle != null) ...[
//                 VehicleDetails(vehicle: parking.vehicle!),
//                 Divider(),
//                 const SizedBox(height: 20.0),
//               ],
//               BlocBuilder<ActiveParkingsBloc, ActiveParkingsState>(
//                 builder: (context, state) {
//                   if (state is ActiveParkingsLoading) {
//                     return CenteredProgressIndicator();
//                   }
//
//                   return ParkingCountdown(
//                     endTime: parking.endTime,
//                     onTimeUp: () => context
//                         .read<ActiveParkingsBloc>()
//                         .add(ActiveParkingEnd(parking: parking)),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20.0),
//               BlocBuilder<ActiveParkingsBloc, ActiveParkingsState>(
//                 builder: (context, state) {
//                   return CustomFilledButton(
//                     onPressed: state is ActiveParkingsLoading
//                         ? null
//                         : () => context
//                             .read<ActiveParkingsBloc>()
//                             .add(ActiveParkingExtend(parking: parking)),
//                     text: "Extend Parking",
//                   );
//                 },
//               ),
//               const SizedBox(height: 30.0),
//               BlocBuilder<ActiveParkingsBloc, ActiveParkingsState>(
//                 builder: (context, state) {
//                   return CustomFilledButton(
//                     onPressed: state is ActiveParkingsLoading
//                         ? null
//                         : () => context
//                             .read<ActiveParkingsBloc>()
//                             .add(ActiveParkingEnd(parking: parking)),
//                     text: "End Parking",
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ActiveParkingScreen extends StatelessWidget {
  const ActiveParkingScreen({
    super.key,
    required this.parking,
  });

  final Parking parking;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveParkingsBloc, ActiveParkingsState>(
      listener: (context, state) {
        if (state is ActiveParkingsFailure) {
          SnackBarService.showError(context, "Error: ${state.message}");
        } else if (state is ActiveParkingExtended) {
          SnackBarService.showSuccess(context, "Parking extended successfully");
        } else if (state is ActiveParkingEnded) {
          AppRouter.pop(context);
          SnackBarService.showSuccess(context, "Parking ended successfully");
        }
      },
      child: BlocBuilder<ActiveParkingsBloc, ActiveParkingsState>(
        builder: (context, state) {
          Parking updatedParking = parking;

          if (state is ActiveParkingsLoaded) {
            updatedParking = state.parkings.firstWhere(
              (p) => p.id == parking.id,
              orElse: () => parking,
            );
          }

          return CustomScaffold(
            title: "Parking",
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Hero(
                    tag: updatedParking.id,
                    child:
                        CustomCircleAvatar(icon: Icons.local_parking_rounded),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Started parking:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        updatedParking.startTime.formatted,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Divider(),
                  const SizedBox(height: 10.0),
                  if (updatedParking.parkingSpace != null) ...[
                    ParkingSpaceDetails(space: updatedParking.parkingSpace!),
                    Divider(),
                    const SizedBox(height: 10.0),
                  ],
                  if (updatedParking.vehicle != null) ...[
                    VehicleDetails(vehicle: updatedParking.vehicle!),
                    Divider(),
                    const SizedBox(height: 20.0),
                  ],
                  ParkingCountdown(
                    endTime: updatedParking.endTime,
                    onTimeUp: () => context
                        .read<ActiveParkingsBloc>()
                        .add(ActiveParkingEnd(parking: updatedParking)),
                  ),
                  const SizedBox(height: 30.0),
                  CustomFilledButton(
                    onPressed: state is ActiveParkingsLoading
                        ? null
                        : () => context
                            .read<ActiveParkingsBloc>()
                            .add(ActiveParkingExtend(parking: updatedParking)),
                    text: "Extend Parking",
                  ),
                  const SizedBox(height: 30.0),
                  CustomFilledButton(
                    onPressed: state is ActiveParkingsLoading
                        ? null
                        : () => context
                            .read<ActiveParkingsBloc>()
                            .add(ActiveParkingEnd(parking: updatedParking)),
                    text: "End Parking",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
