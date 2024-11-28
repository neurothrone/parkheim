import 'package:flutter/material.dart';

import '../../../core/widgets/custom_scaffold.dart';
import '../widgets/add_person_form.dart';

class AddPersonScreen extends StatelessWidget {
  const AddPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Add Person",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: AddPersonForm(),
      ),
    );
  }
}
