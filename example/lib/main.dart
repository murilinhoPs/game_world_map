import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_world_map/game_world_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter game world map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

const String mapPath = 'assets/mapa';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return FutureBuilder(
      future: futureInit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MapPainter(
            imagePath: '$mapPath.jpg',
            mapJsonPath: '$mapPath.json',
            iconsPaths: iconsImagePaths,
            locationToAdd: 'Random',
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
