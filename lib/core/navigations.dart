import 'package:flutter/material.dart';

void navigateAndBack(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateAndReplace(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateTransparentRoute(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    TransparentRoute(builder: (context) => widget),
  );
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
  }) : super(fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }

  @override

  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => '';
}
