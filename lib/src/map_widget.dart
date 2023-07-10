import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_world_map/src/map_painter_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    required this.mapPath,
    required this.locationToAdd,
  }) : super(key: key);
  final String mapPath;
  final String locationToAdd;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late Future futureInit;
  late List<String>? iconsImagePaths;

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent);

    final imagePaths =
        manifestMap.keys.where((String key) => key.contains('.png')).toList();
    iconsImagePaths = imagePaths;
    return iconsImagePaths;
  }

  @override
  void initState() {
    futureInit = _initImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(futureInit);
    return FutureBuilder(
      future: futureInit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MapPainter(
            iconsPaths: iconsImagePaths,
            mapBackgroundPath: widget.mapPath,
            locationToAdd: widget.locationToAdd,
            mapJsonPath: '${widget.mapPath}/mapa.json',
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
