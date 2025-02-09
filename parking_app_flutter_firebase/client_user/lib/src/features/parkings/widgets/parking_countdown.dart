import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

class ParkingCountdown extends StatefulWidget {
  const ParkingCountdown({
    super.key,
    required this.endTime,
    required this.onTimeUp,
  });

  final DateTime endTime;
  final VoidCallback onTimeUp;

  @override
  State<ParkingCountdown> createState() => _ParkingCountdownState();
}

class _ParkingCountdownState extends State<ParkingCountdown> {
  late DateTime _endTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _endTime = widget.endTime;
    _startTimer();
  }

  @override
  void didUpdateWidget(ParkingCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.endTime != widget.endTime) {
      setState(() => _endTime = widget.endTime);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Update UI every second
        setState(() {});
      }

      // Stop the timer and notify the parent when the time is up
      if (DateTime.now().isAfter(_endTime)) {
        widget.onTimeUp();
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = _endTime.difference(now);

    if (remaining.isNegative) {
      return const Text(
        "Parking time expired",
        style: TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Time Left:",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 10.0),
        Text(
          remaining.formatted,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
