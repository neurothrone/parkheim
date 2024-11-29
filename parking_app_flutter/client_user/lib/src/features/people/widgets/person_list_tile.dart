import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import '../../../core/routing/routing.dart';

class PersonListTile extends StatelessWidget {
  const PersonListTile({
    super.key,
    required this.person,
  });

  final Person person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => AppRouter.go(
        context,
        AppRoute.personDetails,
        extra: person,
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_rounded),
          Icon(Icons.numbers_rounded),
        ],
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(person.name),
          Text(person.socialSecurityNumber),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.black45,
      ),
    );
  }
}
