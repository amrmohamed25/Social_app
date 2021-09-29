class ChatModel{
  late String dateTime;
  late String senderUId;
  late String receiverUId;
  late String text;
  late String image;

  ChatModel(this.senderUId,this.receiverUId,this.dateTime,this.text,this.image);

  ChatModel.fromJson(Map<String,dynamic> json){
    dateTime=json['dateTime'];
    senderUId=json['senderUId'];
    receiverUId=json['receiverUId'];
    text=json['text'];
    image=json['image'];
  }
  Map<String,dynamic> toMap(){
    return {
      "dateTime":dateTime,
      "senderUId":senderUId,
      "receiverUId":receiverUId,
      "text":text,
      "image":image
    };
  }
}