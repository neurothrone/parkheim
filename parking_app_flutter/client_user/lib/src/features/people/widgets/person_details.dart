import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

class PersonDetails extends StatelessWidget {
  const PersonDetails({
    super.key,
    required this.person,
  });

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Name:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              person.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Social security number:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              person.socialSecurityNumber,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
