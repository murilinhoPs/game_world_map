<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
## Mini-map for Games

Creates a mini-map widget on Flutter Canvas from a image and its data (locations), it's for games that require a game map. To show the places the player can go or has gone at certain moment, show information about it, show items and show where is the NPCs you can interact with.

This package is primarily made for a game focused on narrative and player decisions, **and** not a real map

## Features
Use this plugin in your Flutter game 👀 or app to:

- Paint the map illustration on canvas
- Show map locations based on it's json data
- Zoom-in and zoom-out map
- Use the map in fullscreen
- Touch the places that are marked and see more info about them
  
<img src="assets/miniMapDemo.gif" style="max-width: 700px" />
    
    you can customize the style (buttons, background...) 
    I prefer a dark background and green buttons

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

#### Initialize map image and it's icons
- You need to create the code below to pass the paths for the map read (***Render the map section***)

````dart
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
````

#### Render the map
- Just pass the props (image and iconsPath) to the MapPainter widget and you're ready! 
  Obs: locationToAdd might be add dinamically from a game logic, I put hard coded as an example
  ###
  > In this example I'm using a FutureBuilder to get the data and pass to the widget because it's easier to explain, but you can use a state-management or anything you want!

```dart
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
```

#### Package lib structure
- In the `lib` folder is just the exports from the package
- The `src` folder is all the logic and components
  - `map_canvas.dart` is where the map is rendered on canvas based on the map data its receive from `MapPainter` and the controller 
  - `map_painter_controller` it manages the logic to add new locations on map, it's required to use with touchable package to update the canvas state
  - `map_painter_widget` contains all the UI and it's basic logic to render the map, also the orientation logic to make fullscreen
    - In the future I'll divide the logic and the screen with a state-manager
- The `widgets` folder is where all the widgets used on `map_painter_widget` is

> I might reorganize the folder structure and files using some design pattern to make it easier to maintain and for others to understand.

## Additional information

If you want to know more about the package, here's my [github](https://github.com/murilinhoPs)! 
