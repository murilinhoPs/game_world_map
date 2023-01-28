import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class MapCanvas extends CustomPainter {
  final BuildContext context;
  final ui.Image image;
  const MapCanvas(
    this.context,
    this.image,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);
    final offset = Offset(size.width / 2, size.height / 2);

    drawImage(myCanvas, size);
    drawFrame(myCanvas, offset, size);
  }

  void drawFrame(TouchyCanvas canvas, Offset offset, Size size) {
    var rect =
        Rect.fromCenter(center: offset, width: size.width, height: size.height);
    var frame = Paint()
      ..color = Color.fromARGB(255, 174, 116, 116)
      ..strokeWidth = 16.0
      ..style = PaintingStyle.fill
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, frame);
    // var rectFill =
    //     Rect.fromCenter(center: offset, width: size.width, height: size.height);
    // var frameFill = Paint()
    //   ..color = ui.Color.fromARGB(56, 174, 116, 116)
    //   ..strokeWidth = 16.0
    //   ..style = PaintingStyle.fill;
    // canvas.drawRect(
    //   rectFill,
    //   frameFill,
    //   onTapDown: (details) =>
    //       print('FrameAddElement: ${details.localPosition}'),
    // );

    var rectTop = Rect.fromLTWH(8, 8, 120, 80);
    var frame3 = Paint()
      ..color = Color.fromARGB(255, 79, 79, 79)
      ..strokeWidth = 16.0
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      rectTop,
      frame3,
      onTapDown: (details) => print('TopLeftRect: ${details.localPosition}'),
    );
  }

  void drawImage(TouchyCanvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImage(
      image,
      Offset.zero,
      paint,
      onTapDown: (details) => print('ImageTap: ${details.localPosition}'),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
