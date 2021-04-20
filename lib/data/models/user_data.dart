import 'dart:convert';

//ahlamelhna@gmail.com - 123456
//Student.addrus.1899@gmail.com - 112233445566

class UserData {
   int id;
   String name;
   String phone;
   String image;
   String address;
   String about;
   String email;
   String join_date;


  UserData({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.address,
    this.about,
    this.email,
    this.join_date
  });

  static UserData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserData(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        image: json['image'],
        address: json['address'],
        about: json['about'],
      email: json['email'],
        join_date: json['join_date'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'phone': phone,
        'image': image,
        'address': address,
        'about': about,
        'email': email,
        'join_date': join_date
      };

    String encodedJson() => json.encode(toJson());

   static UserData decodedJson(String source) =>
       fromJson(json.decode(source));

   @override
   String toString() => name;

}

