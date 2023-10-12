import 'package:flutter/material.dart';

void showWarningSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.all(8),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 39, 44, 47),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 2,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        ],
      )));
}
