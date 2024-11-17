import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_navigation_rail.dart';
import '../../core/enums/screen.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({
    super.key,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final Screen selectedScreen;
  final Function(Screen) onScreenSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Parkings"),
      bottomNavigationBar: CustomNavigationBar(
        selectedScreen: selectedScreen,
        onScreenSelected: onScreenSelected,
      ),
      body: Center(
        child: Text(selectedScreen.label),
      ),
    );
  }
}
