
//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***


import 'dart:convert';

import '../slider_data.dart';

class SliderDataResponse {
   List<SliderData> sliders = [];

   SliderDataResponse(
      {
      this.sliders,
      // this.items
      });

  static SliderDataResponse fromJson(Map<String, dynamic> json) {
    return SliderDataResponse(
        sliders: (null != json['sliders'])? (json['sliders'] as List)
            .map((itemWord) => SliderData.fromJson(itemWord))
            .toList() ?? [] : List<SliderData>()
    );
  }

  Map<String, dynamic> toJson() =>
      {'sliders': sliders};

   String encodedJson() => json.encode(toJson());

   static SliderDataResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



