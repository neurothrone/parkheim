import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/owned_vehicles_list.dart';
import '../widgets/person_details.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
    super.key,
    required this.person,
  });

  final Person person;

  Future<void> _deletePerson(BuildContext context) async {
    final deleteConfirmed = await showConfirmDialog(
      context,
      "Are you sure you want to delete this person?",
    );

    if (!deleteConfirmed) {
      return;
    }

    final result = await RemotePersonRepository.instance.delete(person.id);
    result.when(
      success: (_) {
        AppRouter.pop(context);
        SnackBarService.showSuccess(context, "Person Deleted");
      },
      failure: (error) {
        SnackBarService.showError(context, "Error: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Person Details",
      actions: [
        IconButton(
          onPressed: () async => await _deletePerson(context),
          tooltip: "Delete Person",
          icon: Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCircleAvatar(icon: Icons.person_rounded),
            const SizedBox(height: 20.0),
            PersonDetails(person: person),
            const SizedBox(height: 10.0),
            Divider(),
            const SizedBox(height: 10.0),
            Text(
              "Registered vehicles",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            OwnedVehiclesList(owner: person),
          ],
        ),
      ),
    );
  }
}
