import 'package:flutter/material.dart';

import '../model.dart';

Future<void> showAlertDialog(Location location, BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(location.name),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(location.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
