import 'package:flutter/material.dart';
import 'package:game_world_map/game_world_map.dart';

const String mapPath = 'assets/mapa';
const String addLocation = 'Camp';

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
      home: const MapWidget(
        mapPath: mapPath,
        locationToAdd: addLocation, // dyanmic
      ),
    );
  }
}
