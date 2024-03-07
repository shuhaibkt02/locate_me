import 'dart:io';

import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  const AlertBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit '),
      content: const Text('Are you sure you want to leave?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
