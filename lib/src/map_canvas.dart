import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class MapCanvas extends CustomPainter {
  final BuildContext context;
  MapCanvas(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);
    final offset = Offset(size.width / 2, size.height / 2);

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
    var rectFill =
        Rect.fromCenter(center: offset, width: size.width, height: size.height);
    var frameFill = Paint()
      ..color = Color.fromARGB(255, 174, 116, 116)
      ..strokeWidth = 16.0
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      rectFill,
      frameFill,
      onTapDown: (details) =>
          print('FrameAddElement: ${details.localPosition}'),
    );

    var rect2 = Rect.fromCenter(center: offset * 2, width: 400, height: 400);
    var frame2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 16.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(
      rect2,
      frame2,
      onTapDown: (details) =>
          print('BottomStrokeRect: ${details.localPosition}'),
    );

    var rectTop = Rect.fromLTWH(8, 8, 200, 200);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
