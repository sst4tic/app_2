class PopularCategories {
  final int id;
  final String name;
  final String image;

  const PopularCategories ({
    required this.id,
    required this.name,
    required this.image,

  });
  static PopularCategories fromJson(json) => PopularCategories(
    id: json['id'],
    name: json['name'],
    image: json['image'],
  );
}

