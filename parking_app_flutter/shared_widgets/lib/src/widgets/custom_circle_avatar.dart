import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.icon,
    this.iconSize = 50.0,
    this.radius = 50.0,
  });

  final IconData icon;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: Icon(
        icon,
        size: iconSize,
      ),
    );
  }
}
