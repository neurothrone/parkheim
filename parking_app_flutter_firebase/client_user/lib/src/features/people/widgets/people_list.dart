import 'package:flutter/material.dart';

import 'package:shared/shared.dart';

import 'person_list_tile.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({
    super.key,
    required this.people,
  });

  final List<Person> people;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: people.length,
      itemBuilder: (_, index) => PersonListTile(person: people[index]),
      separatorBuilder: (_, __) => Divider(height: 0),
    );
  }
}
