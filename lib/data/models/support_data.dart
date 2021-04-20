import 'dart:convert';

class SupportData {
  int id ;
  String technical_title;
  String support_title;
  String technical_content;
  String support_content;

  SupportData({
    this.id,
    this.technical_title,
    this.support_title,
    this.technical_content,
    this.support_content,
  });

  static SupportData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return SupportData(
        id: json['id'], technical_title: json['technical_title'], support_title: json['support_title'],
        technical_content: json['technical_content'], support_content: json['support_content']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'technical_title': technical_title, 'support_title': support_title
    , 'technical_content': technical_content, 'support_content': support_content};

  String encodedJson() => json.encode(toJson());

  static SupportData decodedJson(String source) => fromJson(json.decode(source));

}
