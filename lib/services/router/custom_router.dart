import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(seconds: 1);
}
