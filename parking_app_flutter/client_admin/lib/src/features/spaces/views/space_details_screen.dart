import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/widgets/widgets.dart';
import '../state/spaces_list_provider.dart';
import '../widgets/parking_history_list.dart';
import '../widgets/space_details.dart';

class SpaceDetailsScreen extends StatelessWidget {
  const SpaceDetailsScreen({
    super.key,
    required this.space,
  });

  final ParkingSpace space;

  Future<void> _deleteSpace(BuildContext context) async {
    final deleteConfirmed = await showConfirmDialog(
      context,
      "Are you sure you want to delete this parking space?",
    );

    if (!deleteConfirmed) {
      return;
    }

    final result = await RemoteParkingSpaceRepository.instance.delete(space.id);
    result.when(
      success: (_) {
        context.read<SpacesListProvider>().fetchAllSpaces();
        Navigator.of(context).pop();
        SnackBarService.showSuccess(context, "Vehicle Deleted");
      },
      failure: (error) {
        SnackBarService.showError(context, "Error: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Space Details",
        actions: [
          IconButton(
            onPressed: () async => await _deleteSpace(context),
            tooltip: "Delete Space",
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCircleAvatar(icon: Icons.space_dashboard_rounded),
            const SizedBox(height: 20.0),
            SpaceDetails(space: space),
            const SizedBox(height: 10.0),
            Divider(),
            const SizedBox(height: 10.0),
            Text(
              "History",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10.0),
            ParkingHistoryList(space: space),
          ],
        ),
      ),
    );
  }
}
