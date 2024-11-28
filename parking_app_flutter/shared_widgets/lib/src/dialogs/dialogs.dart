import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  String title = "Confirm Deletion",
  String confirmText = "Delete",
  String cancelText = "Cancel",
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text("Are you sure you want to delete this person?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    ) ??
    false;
