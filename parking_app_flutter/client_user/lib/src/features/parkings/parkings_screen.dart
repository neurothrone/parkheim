import 'package:flutter/material.dart';

import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_navigation_rail.dart';
import '../../common/navigation/bottom_tab.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({
    super.key,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final BottomTab selectedScreen;
  final Function(BottomTab) onScreenSelected;

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
