import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'location_info_dialog.dart';
import 'model.dart';

class MapCanvas extends CustomPainter {
  final BuildContext context;
  final ui.Image image;
  final MapCoordinates mapCoordinates;
  const MapCanvas(
    this.context,
    this.image,
    this.mapCoordinates,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);
    final offset = Offset(size.width / 2, size.height / 2);

    drawImage(myCanvas, size);
    drawFrame(myCanvas, offset, size);
    drawFirstCoordinates(myCanvas, size);
  }

  void drawFrame(TouchyCanvas canvas, Offset offset, Size size) {
    var rect =
        Rect.fromCenter(center: offset, width: size.width, height: size.height);
    var frame = Paint()
      ..color = ui.Color.fromARGB(255, 155, 76, 100)
      ..strokeWidth = 24.0
      ..style = PaintingStyle.fill
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, frame);

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

  void drawFirstCoordinates(TouchyCanvas canvas, Size size) {
    var paint1 = Paint()
      ..color = ui.Color.fromARGB(148, 170, 68, 170)
      ..style = PaintingStyle.fill;

    for (var coordinate in mapCoordinates.locations) {
      if (!coordinate.show) return;

      canvas.drawCircle(
          Offset(
            coordinate.x,
            coordinate.y,
          ),
          50,
          paint1, onTapDown: (details) {
        print(
            'Tap ${coordinate.name} (${coordinate.id}): ${details.localPosition}');
        showAlertDialog(coordinate, context);
      });
    }
  }

  void drawNewCoordinate(TouchyCanvas canvas, Size size) {
    var paint1 = Paint()
      ..color = ui.Color.fromARGB(148, 170, 68, 170)
      ..style = PaintingStyle.fill;

    for (var coordinate in mapCoordinates.locations) {
      if (!coordinate.show) return;

      canvas.drawCircle(
          Offset(
            coordinate.x,
            coordinate.y,
          ),
          50,
          paint1, onTapDown: (details) {
        print(
            'Tap ${coordinate.name} (${coordinate.id}): ${details.localPosition}');
        showAlertDialog(coordinate, context);
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
