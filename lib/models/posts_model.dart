class PostsModel {
  PostsModel({
    required this.image,
    required this.content,
  });
  late final String image;
  late final String content;

  PostsModel.fromJson(Map<String, dynamic> json){
    image = json['image'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['content'] = content;
    return data;
  }
}