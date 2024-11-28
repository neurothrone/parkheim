import 'package:flutter/material.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/people_list.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "People",
      actions: [
        IconButton(
          onPressed: () => AppRouter.go(context, AppRoute.addPerson),
          tooltip: "Register Space",
          icon: Icon(Icons.add_rounded),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: PeopleList(),
    );
  }
}
