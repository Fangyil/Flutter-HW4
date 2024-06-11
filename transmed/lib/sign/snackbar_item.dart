import 'package:flutter/material.dart';

void snack(String warning, BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text(warning),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
