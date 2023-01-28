import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import 'map_canvas.dart';
import 'move_map_gesture.dart';

class MapPainter extends StatefulWidget {
  final String imagePath;
  const MapPainter({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<MapPainter> createState() => _MapPainterState();
}

class _MapPainterState extends State<MapPainter> {
  ui.Image? image;

  @override
  void initState() {
    loagImage(widget.imagePath);
    super.initState();
  }

  Future loagImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    setState(() => this.image = image);

    print(image.width.toDouble());
    print(image.height.toDouble());
    print(WidgetsBinding.instance.window.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: image == null
          ? const CircularProgressIndicator()
          : MoveMapGesture(
              child: AspectRatio(
                aspectRatio: 1.04,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  child: SizedBox(
                    width: image!.width.toDouble(),
                    height: image!.height.toDouble(),
                    child: CanvasTouchDetector(
                      gesturesToOverride: const [GestureType.onTapDown],
                      builder: (context) {
                        return CustomPaint(
                          painter: MapCanvas(context, image!),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
