import 'package:flutter/material.dart';

import '../../core/routing/routing.dart';
import '../../core/widgets/widgets.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Spaces",
      actions: [
        IconButton(
          onPressed: () => AppRouter.go(context, AppRoute.addSpace),
          tooltip: "Register Space",
          icon: Icon(Icons.add_rounded),
        ),
      ],
      bottomNavigationBar: CustomNavigationBar(),
      child: Center(
        child: Text("Spaces"),
      ),
    );
  }
}
