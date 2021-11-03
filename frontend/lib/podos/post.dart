class Post {
  String name = "";
  String description = "";
  int price = 0;

  Post({
    required this.name,
    required this.description,
    required this.price,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        name: json['name'],
        description: json['description'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() =>
      {"name": this.name, "description": this.description, "price": this.price};
}
