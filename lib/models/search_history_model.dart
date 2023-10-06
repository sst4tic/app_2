class SearchResults {
  final SearchHistory searchHistory;
  final List<String> popularSearches;

  SearchResults({
    required this.searchHistory,
    required this.popularSearches,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      searchHistory: SearchHistory.fromJson(json['searchHistory']),
      popularSearches: List<String>.from(json['popularSearches']),
    );
  }
}




class SearchHistory {
  SearchHistory({
    required this.success,
    required this.message,
    required this.products,
    required this.texts,
  });

  late final bool success;
  late final String message;
  List<Products> products = [];
  List<Texts> texts = [];

  SearchHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    products =
        List.from(json['products']).map((e) => Products.fromJson(e)).toList();
    texts = List.from(json['texts']).map((e) => Texts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['products'] = products.map((e) => e.toJson()).toList();
    data['texts'] = texts.map((e) => e.toJson()).toList();
    return data;
  }
}

class Products {
  Products({
    required this.id,
    required this.product,
  });

  late final int id;
  late final SearchProduct product;

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = SearchProduct.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product.toJson();
    return data;
  }
}

class SearchProduct {
  SearchProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.media,
  });

  late final int productId;
  late final String name;
  late final price;
  late final String media;

  SearchProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['media'] = media;
    return data;
  }
}

class Texts {
  Texts({
    required this.id,
    required this.query,
  });

  late final int id;
  late final String query;

  Texts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['query'] = query;
    return data;
  }
}
