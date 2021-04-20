
//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***


import 'dart:convert';
import '../categories_data.dart';


class CategoriesResponse {
   int status;
   String msg;
   List<CategoriesData> categories;

   CategoriesResponse(
      {this.status,
      this.msg,
      this.categories});

  static CategoriesResponse fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      status: json['status'],
        msg: json['msg'],
        categories: (null != json['categories'])? (json['categories'] as List)
            .map((itemWord) => CategoriesData.fromJson(itemWord))
            .toList()?? [] : List<CategoriesData>()
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'msg': msg,
        'countryData': categories
      };

   String encodedJson() => json.encode(toJson());

   static CategoriesResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



