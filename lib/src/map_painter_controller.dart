import 'package:flutter/cupertino.dart';

import 'model.dart';

class MapPainterController extends ChangeNotifier {
  late Location location;

  void showNewLocation(bool showLocation) {
    location.show = showLocation;
    notifyListeners();
  }

  void setNewLocation(Location newLocation) {
    location = newLocation;
    notifyListeners();
  }
}
