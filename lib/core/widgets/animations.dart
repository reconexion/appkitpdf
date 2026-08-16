import 'package:flutter/material.dart';

/// Fades + slides a child in on first build. Stagger multiple items by
/// passing an increasing [index].
class FadeSlideIn extends StatelessWidget {
  final int index;
  final Widget child;

  const FadeSlideIn({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Push-style page transition with parallax depth: the incoming page
/// slides in from the right while fading + scaling up, and the page it
/// covers slides slightly left and dims underneath it (and reverses the
/// same way on pop) — instead of just popping in on top of a static
/// screen, so the change of view reads as continuous motion.
Route<T> slidePageRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final incoming = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final outgoing = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.12, 0),
          end: Offset.zero,
        ).animate(incoming),
        child: FadeTransition(
          opacity: incoming,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(incoming),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.08, 0),
              ).animate(outgoing),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0.5).animate(outgoing),
                child: child,
              ),
            ),
          ),
        ),
      );
    },
  );
}
