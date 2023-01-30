import 'package:flutter/cupertino.dart';

import 'model.dart';

class MapPainterController extends ChangeNotifier {
  List<Location>? locations = [];

  void setNewLocation(Location newLocation) {
    if (locations!.contains(newLocation)) {
      return;
    }
    locations!.add(newLocation);
    notifyListeners();
  }
}
