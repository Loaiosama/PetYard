import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage transitionGoRoute<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.ease).animate(animation),
      child: child,
    ),
  );
}
