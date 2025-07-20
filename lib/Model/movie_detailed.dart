// ignore_for_file: unused_import

import 'dart:convert';

class MovieDetailed {
  final int id;
  final String title;
  final String? posterPath;
  final String? overview;
  final DateTime? releaseDate;

  MovieDetailed({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
  });

  factory MovieDetailed.fromJson(Map<String, dynamic> json) => MovieDetailed(
    id: json["id"] ?? 0,
    title: json["title"] ?? "Unknown Movie",
    posterPath: json["poster_path"],
    overview: json["overview"],
    releaseDate: json["release_date"] != null && json["release_date"].isNotEmpty
        ? DateTime.tryParse(json["release_date"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "poster_path": posterPath,
    "overview": overview,
    "release_date": releaseDate != null
        ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
        : null,
  };
}
