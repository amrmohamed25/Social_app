class PostModel {
  late String name;
  late String uId;
  late String dateTime;
  late String text;
  String? image;
  String? postImage;
  String? tags;

  PostModel(
      {required this.name,
      required this.uId,
      required this.dateTime,
      required this.text,
      this.image,
        this.postImage,
      this.tags});

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
    postImage = json['postImage'];
    tags = json['tags'];
  }

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'dateTime': dateTime,
      'text': text,
      'image': image,
      'postImage': postImage,
      'tags': tags
    };
  }
}
