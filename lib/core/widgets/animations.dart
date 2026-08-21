import 'package:flutter/material.dart';

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
