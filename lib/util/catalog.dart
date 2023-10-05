class Catalog {
  final int id;
  final String name;
  final bool hasChild;
  final String? image;

  const Catalog ({
    required this.id,
    required this.name,
    required this.hasChild,
    this.image,

  });
  static Catalog fromJson(json) => Catalog(
    id: json['id'],
    name: json['name'],
    hasChild: json['has_child'],
    image: json['image'],
  );
}

