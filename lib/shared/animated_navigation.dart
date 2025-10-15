import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum RouteTransition {
  fade,
  slideFromRight,
  slideFromBottom,
  scale,
  slideAndFade,
}

class AnimatedRoute extends PageRouteBuilder {
  final Widget child;
  final RouteTransition transition;
  final Duration duration;
  final Curve curve;

  AnimatedRoute({
    required this.child,
    required RouteSettings settings,
    this.transition = RouteTransition.slideAndFade,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  }) : super(
          settings: settings,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              child,
              animation,
              secondaryAnimation,
              transition,
              curve,
            );
          },
        );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    RouteTransition transition,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (transition) {
      case RouteTransition.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case RouteTransition.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransition.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case RouteTransition.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
    }
  }
}

// Navigation helper with animations and feedback
class AnimatedNavigator {
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    RouteTransition transition = RouteTransition.slideAndFade,
    bool withHapticFeedback = true,
  }) async {
    // Provide haptic feedback
    if (withHapticFeedback) {
      _provideHapticFeedback();
    }

    // Add visual feedback for the tap
    _showTapFeedback(context);

    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
    RouteTransition transition = RouteTransition.slideAndFade,
    bool withHapticFeedback = true,
  }) async {
    if (withHapticFeedback) {
      _provideHapticFeedback();
    }

    _showTapFeedback(context);

    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static void _provideHapticFeedback() {
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      // Gracefully handle if haptic feedback is not available
    }
  }

  static void _showTapFeedback(BuildContext context) {
    // Show a subtle visual feedback
    // This could be enhanced with custom animations
  }
}

// Animated button wrapper for category cards
class AnimatedTapButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration animationDuration;
  final double scaleValue;

  const AnimatedTapButton({
    super.key,
    required this.child,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 150),
    this.scaleValue = 0.95,
  });

  @override
  State<AnimatedTapButton> createState() => _AnimatedTapButtonState();
}

class _AnimatedTapButtonState extends State<AnimatedTapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}