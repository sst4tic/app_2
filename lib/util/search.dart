class Search {
  Search({
    required this.products,
    required this.categories,
  });
  late final Products products;
  late final Categories categories;

  Search.fromJson(Map<String, dynamic> json){
    products = Products.fromJson(json['products']);
    categories = Categories.fromJson(json['categories']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['products'] = products.toJson();
    data['categories'] = categories.toJson();
    return data;
  }
}

class Products {
  Products({
    required this.total,
    required this.items,
  });
  late final int total;
  late final List<Items> items;

  Products.fromJson(Map<String, dynamic> json){
    total = json['total'];
    items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['items'] = items.map((e)=>e.toJson()).toList();
    return data;
  }
}

class Items {
  Items({
    required this.id,
    required this.name,
     this.is_favorite,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.link,
     this.media,
  });
  late final int id;
  late final String name;
   bool? is_favorite;
  late final rating;
  late final reviewCount;
  late final String price;
   String? link;
  late final List<Media>? media;

  Items.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    is_favorite = json['is_favorite'];
    rating = json['avg_rating'];
    reviewCount = json['review_count'];
    price = json['price'].toString();
    link = json['link'];
    media = json['media'] != null ? List.from(json['media']).map((e)=>Media.fromJson(e)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_favorite'] = is_favorite;
    data['rating'] = rating;
    data['review_count'] = reviewCount;
    data['price'] = price;
    data['link'] = link;
    data['media'] = media;
    return data;
  }
}

class Media {
  Media({
    required this.id,
    required this.productId,
    required this.type,
    required this.links,
  });
  late final int id;
  late final int productId;
  late final String type;
  late final Links links;


  Media.fromJson(Map<String, dynamic> json){
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
    data['links'] = links.toJson();

    return data;
  }
}

class Links {
  Links({
     this.s3,
     this.cdn,
    required this.local,
  });
   String? s3;
   String? cdn;
  late final Local local;

  Links.fromJson(Map<String, dynamic> json){
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

  Local.fromJson(Map<String, dynamic> json){
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

  Thumbnails.fromJson(Map<String, dynamic> json){
    s150 = json['150'];
    s350 = json['350'];
    s750 = json['750'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['150'] = 150;
    data['350'] = 350;
    data['750'] = 750;
    return data;
  }
}

class Categories {
  Categories({
    required this.total,
    required this.items,
  });
  late final int total;
  late final List<Items> items;

  Categories.fromJson(Map<String, dynamic> json){
    total = json['total'];
    items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['items'] = items.map((e)=>e.toJson()).toList();
    return data;
  }
}