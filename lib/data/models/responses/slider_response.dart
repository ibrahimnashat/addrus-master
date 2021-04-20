//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***

import 'dart:convert';
import 'slider_data_response.dart';

class SliderResponse {
  int status;
  String msg;
  SliderDataResponse data;

  SliderResponse({
    this.status,
    this.msg,
    this.data,
    // this.items
  });

  static SliderResponse fromJson(Map<String, dynamic> json) {
    return SliderResponse(
      status: json['status'],
      msg: json['msg'],
      data: SliderDataResponse.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'msg': msg, 'data': data};

  String encodedJson() => json.encode(toJson());

  static SliderResponse decodedJson(String source) =>
      fromJson(json.decode(source));
}
