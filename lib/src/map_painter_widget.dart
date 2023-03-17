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

class MapPainter extends StatefulWidget {
  final String mapBackgroundPath;
  final String mapJsonPath;
  final List<String>? iconsPaths;
  final String locationToAdd;
  const MapPainter({
    Key? key,
    required this.mapBackgroundPath,
    required this.mapJsonPath,
    required this.locationToAdd,
    this.iconsPaths,
  }) : super(key: key);

  @override
  State<MapPainter> createState() => _MapPainterState();
}

class _MapPainterState extends State<MapPainter> {
  bool isFullscreen = false;
  late Map<String, ui.Image> icons;
  late ui.Image mapImage;
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
      mapImage = image;
    });
  }

  Future loadIconsImage(List<String> paths) async {
    icons = {};

    for (var iconPath in paths) {
      final data = await rootBundle.load(iconPath);
      final bytes = data.buffer.asUint8List();
      final image = await decodeImageFromList(bytes);
      final iconName =
          iconPath.replaceAll(('assets/icons/'), '').replaceAll('.png', '');

      setState(() {
        icons.addAll({iconName: image});
      });
    }
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
    final mapJson = await loadJson(widget.mapJsonPath);
    final mapImage = await loadImage('${widget.mapBackgroundPath}/mapa.jpg');
    final icons = await loadIconsImage(widget.iconsPaths!);

    return [mapImage, mapJson, icons];
  }

  void addNewCoordinate() {
    final id = widget.locationToAdd;
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
      body: FutureBuilder(
        future: futureInit,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return OrientationBuilder(
              builder: ((context, orientation) {
                return orientation == Orientation.portrait
                    ? portrait()
                    : landscape();
              }),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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
          width: mapImage.width.toDouble(),
          height: mapImage.height.toDouble(),
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
                        mapImage,
                        icons,
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

    return BlurredImage(
      imageBytes: imageBytes,
      child: SizedBox(
        width: screenSize.width,
        child: MapBorder(
          radius: 44.0,
          width: 8.0,
          padding: EdgeInsets.zero,
          child: MoveMapGesture(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: mapImage.width.toDouble(),
                height: mapImage.height.toDouble(),
                child: Padding(
                  padding: const EdgeInsets.all(18.2),
                  child: CanvasTouchDetector(
                    gesturesToOverride: const [GestureType.onTapDown],
                    builder: (context) {
                      return CustomPaint(
                        painter: MapCanvas(
                          context,
                          mapImage,
                          icons,
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
}
