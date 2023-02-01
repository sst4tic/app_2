class Catalog {
  final int id;
  final String name;
  final bool hasChild;

  const Catalog ({
    required this.id,
    required this.name,
    required this.hasChild,

  });
  static Catalog fromJson(json) => Catalog(
    id: json['id'],
    name: json['name'],
    hasChild: json['has_child'],
  );
}

