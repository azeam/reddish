import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
    BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
