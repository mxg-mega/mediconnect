import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void goTo(BuildContext context, String route) {
  context.go(route);
}

void pushTo(BuildContext context, String route) {
  context.push(route);
}

void goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  }
}

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