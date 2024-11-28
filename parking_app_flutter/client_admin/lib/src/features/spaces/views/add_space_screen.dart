import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../widgets/add_space_form.dart';

class AddSpaceScreen extends StatelessWidget {
  const AddSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add Space"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AddSpaceForm(),
      ),
    );
  }
}
