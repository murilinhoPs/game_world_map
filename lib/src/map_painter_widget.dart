import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import 'map_canvas.dart';
import 'model.dart';
import 'move_map_gesture.dart';

class MapPainter extends StatefulWidget {
  final String imagePath;
  final String mapJsonPath;
  const MapPainter({
    Key? key,
    required this.imagePath,
    required this.mapJsonPath,
  }) : super(key: key);

  @override
  State<MapPainter> createState() => _MapPainterState();
}

class _MapPainterState extends State<MapPainter> {
  late ui.Image image;
  late MapCoordinates mapCoordinates;

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    setState(() => this.image = image);
  }

  Future loadJson(String path) async {
    final jsonProduct = await rootBundle.loadString(path);
    final jsonResponse = json.decode(jsonProduct);
    final mapCoordinates = MapCoordinates.fromJson(jsonResponse);

    setState(() => this.mapCoordinates = mapCoordinates);
  }

  Future<List> initialize() async {
    final mapImage = await loadImage(widget.imagePath);
    final mapJson = await loadJson(widget.mapJsonPath);

    return [mapImage, mapJson];
  }

  void addNewCoordinate(String id) {
    mapCoordinates.locations
        .firstWhere(
          (element) => element.id == id,
        )
        .show = true;

    setState(() {});
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => addNewCoordinate("Você"),
          icon: const Icon(Icons.add_box),
        ),
      ),
      body: FutureBuilder(
          future: initialize(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MoveMapGesture(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
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
                            painter: MapCanvas(
                              context,
                              image,
                              mapCoordinates,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
