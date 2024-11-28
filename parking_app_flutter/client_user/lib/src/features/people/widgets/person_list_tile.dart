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
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      horizontalTitleGap: 10.0,
      tileColor: Colors.deepPurple.shade50,
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
