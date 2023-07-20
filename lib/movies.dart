// To parse this JSON data, do
//
//     final movies = moviesFromJson(jsonString);

import 'dart:convert';

Movies moviesFromJson(String str) => Movies.fromJson(json.decode(str));

String moviesToJson(Movies data) => json.encode(data.toJson());

class Movies {
  Movies({
    required this.id,
    required this.description,
    required this.name,
    required this.image,
    required this.imdb,
    required this.tr,
    required this.pr,
    required this.kr,
    required this.toi,
    required this.public,
    required this.google,
    required this.li,
  });

  String id;
  String description;
  String name;
  String image;
  String imdb;
  String tr;
  String pr;
  String kr;
  String toi;
  String public;
  String google;
  String li;

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
        id: json["id"],
        description: json["Description"],
        name: json["name"],
        image: json["image"],
        imdb: json["imdb"],
        tr: json["tr"],
        pr: json["pr"],
        kr: json["kr"],
        toi: json["toi"],
        public: json["public"],
        google: json["google"],
        li: json["li"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Description": description,
        "name": name,
        "image": image,
        "imdb": imdb,
        "tr": tr,
        "pr": pr,
        "kr": kr,
        "toi": toi,
        "public": public,
        "google": google,
        "li": li,
      };
}
