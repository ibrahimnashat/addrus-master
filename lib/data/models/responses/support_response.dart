
//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***


import 'dart:convert';
import 'package:adrus/data/models/support_data.dart';

import '../slider_data.dart';

class SupportResponse {
  int status;
  SupportData data ;

  SupportResponse(
      {
        this.status,
      this.data,
      // this.items
      });

  static SupportResponse fromJson(Map<String, dynamic> json) {
    return SupportResponse(
        status: json['status'],
        data: SupportData.fromJson(json['data'])
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'data': data};

   String encodedJson() => json.encode(toJson());

   static SupportResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



