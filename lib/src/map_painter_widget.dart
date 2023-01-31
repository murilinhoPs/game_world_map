import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable/touchable.dart';

import 'map_canvas.dart';
import 'map_painter_controller.dart';
import 'model.dart';
import 'widgets/blurred_image.dart';
import 'widgets/map_border.dart';
import 'widgets/move_map_gesture.dart';

const testAB = true;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => setState(() {
          isFullscreen = !isFullscreen;
          !isFullscreen
              ? SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp])
              : SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeRight]);
        }),
        child: !isFullscreen
            ? Icon(
                Icons.open_in_full_rounded,
                color: Colors.grey[700],
              )
            : Icon(
                Icons.close_fullscreen_rounded,
                color: Colors.grey[700],
              ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return OrientationBuilder(
                  builder: ((context, orientation) {
                    return orientation == Orientation.portrait
                        ? portrait()
                        : testAB
                            ? landscape()
                            : portrait();
                  }),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          SafeArea(
            child: Align(
              alignment:
                  isFullscreen ? Alignment.topRight : Alignment.bottomLeft,
              child: coordinateCount > 1
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: IconButton(
                        onPressed: () {
                          var id = coordinateCount > 0 ? 'Random' : 'Você';
                          addNewCoordinate(id);
                          setState(() => coordinateCount++);
                        },
                        icon: const Icon(
                          Icons.add_box,
                          size: 32,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget portrait() {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      width: screenSize.width,
      height: screenSize.height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: image.width.toDouble(),
          height: image.height.toDouble(),
          child: BlurredImage(
            imageBytes: imageBytes,
            child: MapBorder(
              child: MoveMapGesture(
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
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
    );
  }

  Widget landscape() {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      // padding: const EdgeInsets.all(8.0),
      width: screenSize.width,
      child: MapBorder(
        width: 8.0,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: image.width.toDouble(),
              height: image.height.toDouble(),
              child: BlurredImage(
                imageBytes: imageBytes,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MoveMapGesture(
                    child: CanvasTouchDetector(
                      gesturesToOverride: const [GestureType.onTapDown],
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
      ),
    );
  }
}
