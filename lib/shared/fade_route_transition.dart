import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  @override

  ///Settings related to route
  final RouteSettings settings;

  ///This will be the page routing towards nullable
  final Widget? page;
  final Widget route;

  FadeRoute({required this.settings, this.page, required this.route,}) : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,) =>
                page!,
            settings: settings,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: route,
                ));
}
