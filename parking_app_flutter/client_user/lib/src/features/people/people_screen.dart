import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "People",
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("People"),
      ),
    );
  }
}
