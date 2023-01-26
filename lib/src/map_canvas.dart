import 'package:flutter/material.dart';

class MapCanvas extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final offset = Offset(size.width / 2, size.height / 2);

    drawFrame(canvas, offset, size);
  }

  void drawFrame(Canvas canvas, Offset offset, Size size) {
    var rect =
        Rect.fromCenter(center: offset, width: size.width, height: size.height);
    var frame = Paint()
      ..color = Color.fromARGB(255, 174, 116, 116)
      ..strokeWidth = 16.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, frame);

    var rect2 = Rect.fromCenter(center: offset, width: 400, height: 400);
    var frame2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 16.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect2, frame2);

    var rectTop = Rect.fromLTWH(8, 8, 300, 400);
    var frame3 = Paint()
      ..color = Color.fromARGB(255, 79, 79, 79)
      ..strokeWidth = 16.0
      ..style = PaintingStyle.fill;
    canvas.drawRect(rectTop, frame3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
