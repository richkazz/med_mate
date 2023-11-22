import 'package:flutter/widgets.dart';

/// Custom page route that slides in from the right.
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  /// Constructor for SlidePageRoute.
  SlidePageRoute({required this.page})
      : super(
          // Define the page to be displayed.
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,

          // Define the transition animation.
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            // Define the starting and ending offset for the slide animation.
            const begin = Offset(1, 0);
            const end = Offset.zero;

            // Define the animation curve for the slide.
            const curve = Curves.easeInOut;

            // Create a tween to interpolate between the starting and
            // ending offsets.
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the tween to the animation.
            final offsetAnimation = animation.drive(tween);

            // Use a SlideTransition to perform the slide animation on
            //the child.
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );

  /// The widget representing the page to be displayed.
  final Widget page;
}
