class SocialUserModel{
  late String name;
  late String phone;
  late String email;
  late String uId;
  String? image;
  String? cover;
  String? bio;

  SocialUserModel({required this.name,required this.phone,required this.email,required this.uId,this.image,this.cover,this.bio});

  setName(String name){
    this.name=name;
  }

  setBio(String bio){
    this.bio=bio;
  }

  setPhone(String phone){
    this.phone=phone;
  }

  setProfileImage(String profileUrl){
    this.image=profileUrl;
  }

  setCoverImage(String coverUrl){
    this.cover=coverUrl;
  }

  SocialUserModel.fromJson(Map<String,dynamic> json){
    name=json['name'];
    phone=json['phone'];
    email=json['email'];
    uId=json['uId'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'phone':phone,
      'email':email,
      'uId':uId,
      'image':image,
      'cover':cover,
      'bio':bio
    };
  }
}