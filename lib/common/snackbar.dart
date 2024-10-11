import 'package:flutter/material.dart';
import 'package:lingopanda_assessment/utils/styles.dart';

void showCustomSnackbar(
  BuildContext context,
  String text, {
  bool isError = true,
}) {
  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Row(
      children: [
        const SizedBox(
          width: 4.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Flexible(
          child: Text(
            text,
            style: Styles.inputTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
