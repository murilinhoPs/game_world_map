import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'map_painter_controller.dart';
import 'widgets/location_info_dialog.dart';

class MapCanvas extends CustomPainter {
  final BuildContext context;
  final ui.Image mapImage;
  final Map<String, ui.Image> icons;
  final MapPainterController controller;
  const MapCanvas(
    this.context,
    this.mapImage,
    this.icons,
    this.controller,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

    drawImage(myCanvas, size);
    drawCoordinate(myCanvas, size);
  }

  void drawImage(TouchyCanvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImage(
      mapImage,
      Offset.zero,
      paint,
      onTapDown: (details) => print('ImageTap: ${details.localPosition}'),
    );
  }

  void drawCoordinate(TouchyCanvas canvas, Size size) {
    var imagePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke;

    for (var index = 0; index < controller.locations!.length; index++) {
      var coordinate = controller.locations![index];

      if (coordinate.show) {
        var iconImage = icons[coordinate.icon]!;

        canvas.drawImage(
          iconImage,
          Offset(
            coordinate.x - iconImage.width / 2,
            coordinate.y - iconImage.width / 2,
          ),
          imagePaint,
          onTapDown: (details) {
            print(
                'Tap ${coordinate.name} (${coordinate.id}): ${details.localPosition}');
            showAlertDialog(coordinate, context);
          },
        );
      }
    }
  }

  @override
  bool shouldRepaint(MapCanvas oldDelegate) {
    return true;
  }
}
