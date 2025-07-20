// ignore_for_file: unused_import

import 'dart:convert';

class TvRecommendations {
  final int page;
  final List<TvResult> results;
  final int totalPages;
  final int totalResults;

  TvRecommendations({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvRecommendations.fromJson(Map<String, dynamic> json) => TvRecommendations(
        page: json["page"] ?? 1,
        results: List<TvResult>.from(
            (json["results"] ?? []).map((x) => TvResult.fromJson(x))),
        totalPages: json["total_pages"] ?? 0,
        totalResults: json["total_results"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class TvResult {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;
  final String? firstAirDate;
  final List<int>? genreIds;
  final double? popularity;
  final double? voteAverage;
  final int? voteCount;

  TvResult({
    required this.id,
    this.name,
    this.posterPath,
    this.overview,
    this.firstAirDate,
    this.genreIds,
    this.popularity,
    this.voteAverage,
    this.voteCount,
  });

  factory TvResult.fromJson(Map<String, dynamic> json) => TvResult(
        id: json["id"] ?? 0,
        name: json["name"],
        posterPath: json["poster_path"],
        overview: json["overview"],
        firstAirDate: json["first_air_date"],
        genreIds: List<int>.from((json["genre_ids"] ?? []).map((x) => x)),
        popularity: (json["popularity"] as num?)?.toDouble(),
        voteAverage: (json["vote_average"] as num?)?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "poster_path": posterPath,
        "overview": overview,
        "first_air_date": firstAirDate,
        "genre_ids": genreIds == null
            ? []
            : List<dynamic>.from(genreIds!.map((x) => x)),
        "popularity": popularity,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}