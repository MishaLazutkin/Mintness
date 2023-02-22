import 'package:flutter/material.dart';

class EmptyAnimationRouter<T> extends MaterialPageRoute<T> {
  EmptyAnimationRouter({WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child
  ) => child;
}

enum AnimationDirection {vertical, horizontal, fromRight, fromLeft}

class AnimatedPageRoute extends PageRouteBuilder {
  final AnimationDirection animationDirection;
  final Widget page;
  final Curve curve;

  AnimatedPageRoute(
    this.animationDirection,
    this.page, {
    this.curve = Curves.easeInOut,
  }) : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) => page,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) => SlideTransition(
      position: Tween<Offset>(
        begin: animationDirection == AnimationDirection.vertical
          ? const Offset(0, 1)
          : animationDirection == AnimationDirection.fromRight
            ? const Offset(1, 0)
            : const Offset(-1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve)).animate(animation),
      child: child,
    ),
  );
}
