import 'dart:convert';

import 'class_data.dart';
import 'instructor_data.dart';

class ContentData {
  int id;
  String title;
  String video_url;
  String url;
  bool videoDownloaded;





  ContentData(
      {this.id,
      this.title,
      this.video_url,
        this.url,
        this.videoDownloaded
      });

  static ContentData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return ContentData(
      id: json['id'],
      title: json['title'],
      video_url: json['video_url'],
        url: json['url'],
        videoDownloaded: json['videoDownloaded']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'video_url': video_url,
    'url': url,
    'videoDownloaded': videoDownloaded
      };

  String encodedJson() => json.encode(toJson());

  static ContentData decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => title;
}
