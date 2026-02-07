import 'package:flutter/material.dart';

void navigateTo(BuildContext context, String route) {
  Navigator.pushNamed(context, route);
}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}

void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
}