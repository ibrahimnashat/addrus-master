import 'dart:convert';

class SliderData {
  int id ;
  String image;
  String title;
String subTitle;


  SliderData({
    this.id,
    this.image,
    this.title,
    this.subTitle
  });

  static SliderData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return SliderData(
        id: json['id'], image: json['image'], title: json['title'], subTitle: json['subTitle']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'image': image, 'title': title, 'subTitle': subTitle};

  String encodedJson() => json.encode(toJson());

  static SliderData decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => 'Slider(image: $title)';
}
