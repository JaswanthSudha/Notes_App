import 'package:flutter/material.dart';

Future<bool> errorDialogShow(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("UnKnown Error"),
          content: const Text("Please Check your Details"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("ok")),
          ],
        );
      }).then((value) => value ?? true);
}
