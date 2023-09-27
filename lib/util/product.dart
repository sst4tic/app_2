class Product {
  Product({
    required this.id,
    required this.name,
    this.categoryName,
    required this.price,
    required this.is_favorite,
    required this.link,
    this.media,
    this.rating,
    this.reviewCount,
  });

  late final int id;
  late final String name;
  String? categoryName;
  late final String price;
  bool? is_favorite;
  late final String link;
  List<Media>? media;
  late final int? rating;
  late final int? reviewCount;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryName = json['category_name'];
    price = json['price'].toString();
    is_favorite = json['is_favorite'];
    link = json['link'];
    media =
        (json["media"] as List?)?.map((a) => Media.fromJson(a)).toList() ?? [];
    rating = json['avg_rating'] ?? 0;
    reviewCount = json['review_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_name'] = categoryName;
    data['media'] = media?.map((e) => e.toJson()).toList();
    data['rating'] = rating;
    data['review_count'] = reviewCount;
    return data;
  }
}

class Media {
  Media({
    required this.id,
    required this.productId,
    required this.type,
    this.links,
  });

  late final int id;
  late final int productId;
  late final String type;
  Links? links;

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    type = json['type'];
    links = Links.fromJson(json['links']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['type'] = type;
    data['links'] = links?.toJson();
    return data;
  }
}

class Links {
  Links({
    this.s3,
    this.cdn,
    required this.local,
  });

  int? s3;
  int? cdn;
  late final Local local;

  Links.fromJson(Map<String, dynamic> json) {
    s3 = json['s3'];
    cdn = json['cdn'];
    local = Local.fromJson(json['local']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['s3'] = s3;
    data['cdn'] = cdn;
    data['local'] = local.toJson();
    return data;
  }
}

class Local {
  Local({
    required this.full,
    required this.thumbnails,
  });

  late final String full;
  late final Thumbnails thumbnails;

  Local.fromJson(Map<String, dynamic> json) {
    full = json['full'];
    thumbnails = Thumbnails.fromJson(json['thumbnails']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['full'] = full;
    data['thumbnails'] = thumbnails.toJson();
    return data;
  }
}

class Thumbnails {
  Thumbnails({
    required this.s150,
    required this.s350,
    required this.s750,
  });

  late final String s150;
  late final String s350;
  late final String s750;

  Thumbnails.fromJson(Map<String, dynamic> json) {
    s150 = json['150'];
    s350 = json['350'];
    s750 = json['750'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['150'] = s150;
    data['350'] = s350;
    data['750'] = s750;
    return data;
  }
}
