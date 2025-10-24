class FavoriteCity {
  final int? id;
  final String name;

  FavoriteCity({this.id, required this.name});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
  };

  factory FavoriteCity.fromMap(Map<String, dynamic> map) =>
      FavoriteCity(id: map['id'], name: map['name']);
}