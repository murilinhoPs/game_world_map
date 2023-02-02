# How to use this package

### Loading icons(images) to use on map
- You need to create the code below to pass the paths for the map read

````
  late List<String> iconsImagePaths;

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent);

    final imagePaths =
        manifestMap.keys.where((String key) => key.contains('.png')).toList();
    iconsImagePaths = imagePaths;

    print(iconsImagePaths);
  }

  @override
  void initState() {
    _initImages();
    super.initState();
  }
````
