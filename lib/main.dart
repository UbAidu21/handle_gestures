import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResizebleContainer(height: 21, width: 33),
    );
  }
}

class ResizebleContainer extends StatefulWidget {
  const ResizebleContainer(
      {super.key, required this.height, required this.width});
  final double width;
  final double height;

  @override
  State<ResizebleContainer> createState() => _ResizebleContainerState();
}

class _ResizebleContainerState extends State<ResizebleContainer> {
  Offset? previousOffset;

  @override
  Widget build(BuildContext context) {
    double containerHeight = widget.height;
    double containerWidth = widget.width;
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        if (previousOffset == null) {
          previousOffset = details.focalPoint;
          return;
        }

        double deltaY = previousOffset!.dy - details.focalPoint.dy;
        double deltaX = previousOffset!.dx - details.focalPoint.dx;

        double newHeight = containerHeight - deltaY;
        double newWidth = containerWidth - deltaX;

        // Ensure the size doesn't go beyond the specified range
        if ((newHeight <= 200 && newWidth <= 300) &&
            (newHeight > 100 && newWidth > 100)) {
          setState(() {
            containerHeight = newHeight;
            containerWidth = newWidth;
          });
        }

        // Update the previous offset for the next iteration
        previousOffset = details.focalPoint;

        log(containerHeight.toString());
        log(containerWidth.toString());
      },
      onScaleEnd: (details) {
        // Reset previous offset when scaling ends
        previousOffset = null;
      },
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: containerHeight,
          width: containerWidth,
          color: Colors.blue,
          child: Center(
            child: Text(
              'Height: $containerHeight\nWidth: $containerWidth',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
