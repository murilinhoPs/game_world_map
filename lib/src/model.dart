class MapCoordinates {
  String? name;
  late int id;
  late List<Location> locations;

  MapCoordinates({
    required this.id,
    required this.name,
    required this.locations,
  });

  MapCoordinates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['locations'] != null) {
      locations = <Location>[];
      json['locations'].forEach((v) {
        locations.add(Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['locations'] = locations.map((v) => v.toJson()).toList();
    return data;
  }
}

class Location {
  late String name;
  late String id;
  late String description;
  late double x;
  late double y;
  late bool show;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.x,
    required this.y,
    required this.show,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    show = json['show'];
    x = json['x'] is int ? (json['x'] as int).toDouble() : json['x'];
    y = json['y'] is int ? (json['y'] as int).toDouble() : json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['y'] = y;
    data['x'] = x;
    data['show'] = show;
    return data;
  }
}
