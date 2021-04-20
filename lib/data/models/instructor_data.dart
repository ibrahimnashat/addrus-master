import 'dart:convert';

class InstructorData {
  int id ;
  String avatar;
  String name;

  InstructorData({
    this.id,
    this.avatar,
    this.name,
  });

  static InstructorData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return InstructorData(
        id: json['id'], avatar: json['avatar'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'avatar': avatar, 'name': name};

  String encodedJson() => json.encode(toJson());

  static InstructorData decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => 'Slider(avatar: $name)';
}
