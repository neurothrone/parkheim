import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../../../core/routing/routing.dart';
import '../../../core/services/services.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/people_list.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final RemotePersonRepository _personRepository =
      RemotePersonRepository.instance;

  Future<void> _deletePerson(Person person) async {
    // TODO: Show confirmation dialog

    final result = await _personRepository.delete(person.id);
    result.when(
      success: (_) {
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
      title: "People",
      actions: [
        IconButton(
          onPressed: () => AppRouter.go(context, AppRoute.addPerson),
          tooltip: "Add Person",
          icon: Icon(Icons.add_rounded),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: FutureBuilder<Result<List<Person>, String>>(
        future: _personRepository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data!;
            return result.when(
              success: (List<Person> people) => PeopleList(people: people),
              failure: (error) => Center(child: Text("Error: $error")),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return CenteredProgressIndicator();
        },
      ),
    );
  }
}
