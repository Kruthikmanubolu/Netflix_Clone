import 'dart:convert';

TrendingMovies trendingMoviesFromJson(String str) =>
    TrendingMovies.fromJson(json.decode(str));

String trendingMoviesToJson(TrendingMovies data) => json.encode(data.toJson());

class TrendingMovies {
  final int page;
  final List<Result> results;
  final int totalPages;
  final int totalResults;

  TrendingMovies({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TrendingMovies.fromJson(Map<String, dynamic> json) => TrendingMovies(
        page: json["page"] ?? 1,
        results: List<Result>.from(
            (json["results"] ?? []).map((x) => Result.fromJson(x))),
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

class Result {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final DateTime? releaseDate;
  final String? title;
  final bool video;
  final double? voteAverage;
  final int? voteCount;
  final String? mediaType; // Handle media_type for trending endpoint

  Result({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    required this.video,
    this.voteAverage,
    this.voteCount,
    this.mediaType,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from((json["genre_ids"] ?? []).map((x) => x)),
        id: json["id"] ?? 0,
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: (json["popularity"] as num?)?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] != null &&
                json["release_date"].isNotEmpty
            ? DateTime.tryParse(json["release_date"])
            : null,
        title: json["title"] ?? "Unknown Title",
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] as num?)?.toDouble(),
        voteCount: json["vote_count"],
        mediaType: json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate != null
            ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
            : null,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "media_type": mediaType,
      };
}