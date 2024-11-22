import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Spaces",
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("Spaces"),
      ),
    );
  }
}
