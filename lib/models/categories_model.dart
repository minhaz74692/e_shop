import 'dart:core';
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String name;
  String id;
  String image;
  CategoryModel({
    required this.name,
    required this.id,
    required this.image,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json['name'],
        id: json['id'],
        image: json['image_url'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': image,
      };
}
// class EWasteModel {
//   String id;
//   String title;
//   EWasteModel({
//     required this.id,
//     required this.title,
//   });
//   factory EWasteModel.fromJson(Map<String, dynamic> json) => EWasteModel(
//         id: json['id'],
//         title: json['title'],
//       );
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': title,
//       };
// }
