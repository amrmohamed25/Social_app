

class CommentModel {
  late String username;
  String? image;
  late String text;

  CommentModel(
      {required this.username, required this.image, required this.text});

  CommentModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    image = json['image'];
    text = json['text'];
  }

  Map<String,dynamic> toMap() {
    return {"username": username, "image": image, "text": text};
  }
}
