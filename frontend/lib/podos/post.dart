class Post {
  String title;
  String body;
  String author;
  String id;
  int upvotes;
  int downvotes;

  Post(
      {required this.title,
      required this.body,
      required this.id,
      this.upvotes = 0,
      this.downvotes = 0,
      this.author = ""});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        title: json['title'],
        body: json['body'],
        id: json['_id'],
        upvotes: json['upvotes'],
        downvotes: json['downvotes'],
        author: json['author']);
  }

  Map<String, dynamic> toJson() => {
        "title": this.title,
        "body": this.body,
      };
}
