import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'map_canvas.dart';
import 'move_map_gesture.dart';

// class MapPainter extends StatefulWidget {
//   const MapPainter({Key? key}) : super(key: key);

//   @override
//   State<MapPainter> createState() => _MapPainterState();
// }

class MapPainter extends StatelessWidget {
  const MapPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MoveMapGesture(
        child: AspectRatio(
          aspectRatio: 2.0,
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: CanvasTouchDetector(
              gesturesToOverride: const [GestureType.onTapDown],
              builder: (context) {
                return CustomPaint(
                  painter: MapCanvas(context),
                );
              }),
        ),
      ),
    );
  }
}
