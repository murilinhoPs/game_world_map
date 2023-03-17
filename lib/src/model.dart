class MapCoordinates {
  String? name;
  late int id;
  late String background;
  late List<Location> locations;

  MapCoordinates({
    required this.id,
    required this.name,
    required this.locations,
  });

  MapCoordinates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    background = json['background'];
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
    data['background'] = background;
    data['locations'] = locations.map((v) => v.toJson()).toList();
    return data;
  }
}

class Location {
  late String name;
  late String id;
  late String icon;
  late String description;
  late double x;
  late double y;
  late bool show;

  Location({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.x,
    required this.y,
    required this.show,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    show = json['show'];
    x = json['x'] is int ? (json['x'] as int).toDouble() : json['x'];
    y = json['y'] is int ? (json['y'] as int).toDouble() : json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['description'] = description;
    data['y'] = y;
    data['x'] = x;
    data['show'] = show;
    return data;
  }
}
