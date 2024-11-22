import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.title,
    required this.child,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget child;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade100,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading,
        centerTitle: centerTitle,
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
