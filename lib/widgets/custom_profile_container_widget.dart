import 'package:flutter/material.dart';

class CustomContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from the top-left
    path.lineTo(
        0,
        size.height +
            10); // Move to the bottom-left corner, slightly above the bottom edge

    // Create a symmetrical inward curve at the bottom center
    path.quadraticBezierTo(
      size.width / 2, // Control point horizontally in the middle
      size.height - 25, // Pull the center inward slightly downwards
      size.width, // End point at the bottom-right corner
      size.height + 10, // End point slightly above the bottom-right
    );

    // Draw the right side back to the top-right corner
    path.lineTo(size.width, 0);

    // Complete the path by drawing a line back to the starting point
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
