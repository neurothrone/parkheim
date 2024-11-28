import 'package:flutter/material.dart';

import '../../core/widgets/custom_scaffold.dart';

class AddSpaceScreen extends StatelessWidget {
  const AddSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Add Space",
      child: Center(
        child: Text("Add Space"),
      ),
    );
  }
}
