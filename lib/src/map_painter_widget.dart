import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import 'map_canvas.dart';
import 'map_painter_controller.dart';
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
  int coordinateCount = 0;
  bool isFullscreen = false;
  late ui.Image image;
  late Uint8List imageBytes;
  late MapCoordinates mapCoordinates;
  late Future futureInit;
  final MapPainterController controller = MapPainterController();

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    setState(() {
      imageBytes = bytes;
      this.image = image;
    });
  }

  Future loadJson(String path) async {
    final jsonProduct = await rootBundle.loadString(path);
    final jsonResponse = json.decode(jsonProduct);
    final mapCoordinates = MapCoordinates.fromJson(jsonResponse);
    setState(() => this.mapCoordinates = mapCoordinates);

    for (var coordinate in mapCoordinates.locations) {
      if (!coordinate.show) return;
      controller.setNewLocation(coordinate);
    }
  }

  Future<List> initialize() async {
    final mapImage = await loadImage(widget.imagePath);
    final mapJson = await loadJson(widget.mapJsonPath);

    return [mapImage, mapJson];
  }

  void addNewCoordinate(String id) {
    mapCoordinates.locations.firstWhere((element) {
      final correctLocation = element.id == id;
      if (correctLocation) {
        controller.setNewLocation(element);
      }
      return correctLocation;
    }).show = true;
  }

  @override
  void initState() {
    futureInit = initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          isFullscreen = !isFullscreen;

          !isFullscreen
              ? SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp])
              : SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeRight]);
        }),
        child: !isFullscreen
            ? const Icon(Icons.open_in_full_rounded)
            : const Icon(Icons.close_fullscreen_rounded),
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: futureInit,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.none,
                      child: SizedBox(
                        width: image.width.toDouble(),
                        height: image.height.toDouble(),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageBytes),
                              opacity: 0.7,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 115, 37, 60),
                                  width: 20.0,
                                ),
                              ),
                              child: MoveMapGesture(
                                child: CanvasTouchDetector(
                                  gesturesToOverride: const [
                                    GestureType.onTapDown
                                  ],
                                  builder: (context) {
                                    return CustomPaint(
                                      painter: MapCanvas(
                                        context,
                                        image,
                                        controller,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              }),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: coordinateCount > 1
                  ? null
                  : IconButton(
                      onPressed: () {
                        var id = coordinateCount > 0 ? 'Random' : 'Você';
                        addNewCoordinate(id);
                        setState(() => coordinateCount++);
                      },
                      icon: const Icon(Icons.add_box),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
