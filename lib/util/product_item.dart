class ProductItem {
  ProductItem({
    required this.id,
    required this.name,
    this.categoryName,
    this.categoryId,
    required this.sku,
    required this.price,
    this.description,
    required this.is_favorite,
    this.media,
    required this.availability,
    required this.rating,
    required this.reviewCount,
    required this.reviewCheck,
  });

  late final int id;
  late final String name;
  String? categoryName;
  var categoryId;
  late final String sku;
  late final String price;
  String? description;
  late final bool is_favorite;
  List<Media>? media;
  late final String availability;
  late final rating;
  late final int reviewCount;
  late final List<Reviews> reviews;
  late final bool reviewCheck;

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    sku = json['sku'];
    price = json['price'].toString();
    description = json['description'];
    is_favorite = json['is_favorite'];
    media =
        (json["media"] as List?)?.map((a) => Media.fromJson(a)).toList() ?? [];
    availability = json['availability'].toString();
    rating = json['avg_rating'];
    reviewCount = json['review_count'];
    reviews =
        (json["reviews"] as List?)?.map((a) => Reviews.fromJson(a)).toList() ??
            [];
    reviewCheck = json['reviewCheck'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['sku'] = sku;
    data['price'] = price;
    data['description'] = description;
    data['media'] = media?.map((e) => e.toJson()).toList();
    data['availability'] = availability;
    data['avg_rating'] = rating;
    data['review_count'] = reviewCount;
    data['reviews'] = reviews.map((e) => e.toJson()).toList();
    data['reviewCheck'] = reviewCheck;
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

class Reviews {
  Reviews({
    required this.id,
    required this.user,
    required this.rating,
    required this.body,
    required this.status,
    required this.date,
  });

  late final int id;
  late final User user;
  late final int rating;
  late final String body;
  late final int status;
  late final String date;

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = User.fromJson(json['user']);
    rating = json['rating'];
    body = json['body'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user.toJson();
    data['rating'] = rating;
    data['body'] = body;
    data['status'] = status;
    data['date'] = date;
    return data;
  }
}

class User {
  User({
    required this.id,
    this.fullName,
    required this.phone,
  });

  late final int id;
  late final String? fullName;
  late final String phone;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone'] = phone;
    return data;
  }
}
