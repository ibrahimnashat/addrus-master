import 'dart:convert';

class CategoriesData {
   int id = 0;
   String name = '';
   String icon = '' ;
   String image = '' ;


  CategoriesData({
    this.id,
    this.name,
    this.icon,
    this.image,
  });

  static CategoriesData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CategoriesData(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        image: json['image']);
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'icon': icon,
        'image': image
      };

    String encodedJson() => json.encode(toJson());

   static CategoriesData decodedJson(String source) =>
       fromJson(json.decode(source));

   @override
   String toString() =>
       'Category(name: $name)';

}

