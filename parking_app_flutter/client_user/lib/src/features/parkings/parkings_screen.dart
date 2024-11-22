import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Parkings",
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("Parkings"),
      ),
    );
  }
}
