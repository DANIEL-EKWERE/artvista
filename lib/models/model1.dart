import 'dart:convert';

class Category1 {
  final dynamic id;
  final String title;
  final String image;
  final String updated;

  Category1(
      {required this.id,
      required this.title,
      required this.image,
      required this.updated});

  factory Category1.fromJson(Map<String, dynamic> json) {
    return Category1(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      updated: json['updated'],
    );
  }
}

class Author {
  final int id;
  final String image;
  final dynamic bio;
  final dynamic user;

  Author(
      {required this.id,
      required this.image,
      required this.bio,
      required this.user});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      image: json['image'],
      bio: json['bio'],
      user: json['user'],
    );
  }
}

class Youtube {
  final String video;

  Youtube({required this.video});

  factory Youtube.fromJson(Map<String, dynamic> json) {
    return Youtube(
      video: json['video'],
    );
  }
}

// "youtube": {
//                 "id": 1,
//                 "created": "2024-03-09T15:29:02.819674Z",
//                 "video": "https://youtu.be/LIPicvqget4?feature=shared",
//                 "title": "tee jay",
//                 "updated": "2024-03-09T15:29:02.819674Z"
//             },

Post allPosts(String str) => Post.fromJson(json.decode(str));

List<Post> allPostFromJson2(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

//String allPostToJson2(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  final dynamic id;
  final String title;
  final String image;
  final String body;
  final String publish;
  final String created;
  final String updated;
  final String status;
  final Category1 category;
  final Author author;
  final dynamic video;
  final String slug;

  Post({
    required this.id,
    required this.title,
    required this.image,
    required this.body,
    required this.publish,
    required this.created,
    required this.updated,
    required this.status,
    required this.category,
    required this.author,
    required this.video,
    required this.slug,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      body: json['body'],
      publish: json['publish'],
      created: json['created'],
      updated: json['updated'],
      status: json['status'],
      category: Category1.fromJson(json['category']),
      author: Author.fromJson(json['author']),
      video: json['video'],
      slug: json['slug'],
    );
  }
}

void main() {
  List<Post> data = [
    Post.fromJson({
      "id": 86,
      "title": "Newest character",
      "image":
          "https://audrey-art.com/media/featured_image/2023/12/10/Untitled588_20230625004526_transcpr.jpg",
      "body": """
        I drew my latest female character... I've not even given her a name yet...which I'll do soon.

        I did a short edit of this masterpiece... please watch and air your comments, guys... thanks ❤️
      """,
      "publish": "2023-12-06T17:54:14Z",
      "created": "2023-12-06T17:55:18.774931Z",
      "updated": "2023-12-10T19:14:41.719657Z",
      "status": "published",
      "category": {
        "id": 8,
        "title": "character-design",
        "image":
            "https://audrey-art.com/media/cate/2023/07/15/character_design.png",
        "updated": "2023-10-24T18:32:24.326533Z"
      },
      "author": {
        "id": 1,
        "image": "https://audrey-art.com/media/profile_pics/1000045256.jpg",
        "bio": "",
        "user": 2
      },
      "youtube": 21,
      "slug": "newest-character"
    }),
  ];

  // Use the 'data' list of Post objects in your Dart code as needed.
}
