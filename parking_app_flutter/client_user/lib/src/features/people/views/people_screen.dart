import 'package:flutter/material.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_widgets/shared_widgets.dart';

import '../../../core/routing/routing.dart';
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
