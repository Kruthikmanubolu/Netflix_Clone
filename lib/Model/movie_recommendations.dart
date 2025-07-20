// To parse this JSON data, do
//
//     final movieRecommendations = movieRecommendationsFromJson(jsonString);

import 'dart:convert';

MovieRecommendations movieRecommendationsFromJson(String str) => MovieRecommendations.fromJson(json.decode(str));

String movieRecommendationsToJson(MovieRecommendations data) => json.encode(data.toJson());

class MovieRecommendations {
    int page;
    List<Result> results;
    int totalPages;
    int totalResults;

    MovieRecommendations({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory MovieRecommendations.fromJson(Map<String, dynamic> json) => MovieRecommendations(
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    bool adult;
    String? backdropPath;
    int id;
    String title;
    String? originalTitle;
    String? overview;
    String? posterPath;
    MediaType mediaType;
    OriginalLanguage? originalLanguage;
    List<int> genreIds;
    double? popularity;
    DateTime? releaseDate;
    bool video;
    double? voteAverage;
    int? voteCount;

    Result({
        required this.adult,
        this.backdropPath,
        required this.id,
        required this.title,
        this.originalTitle,
        this.overview,
        this.posterPath,
        required this.mediaType,
        this.originalLanguage,
        required this.genreIds,
        this.popularity,
        this.releaseDate,
        required this.video,
        this.voteAverage,
        this.voteCount,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        id: json["id"] ?? 0,
        title: json["title"] ?? "Unknown Title",
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        mediaType: mediaTypeValues.map[json["media_type"]] ?? MediaType.MOVIE,
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        genreIds: List<int>.from((json["genre_ids"] ?? []).map((x) => x)),
        popularity: (json["popularity"] as num?)?.toDouble(),
        releaseDate: json["release_date"] != null && json["release_date"].isNotEmpty
            ? DateTime.tryParse(json["release_date"])
            : null,
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] as num?)?.toDouble(),
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaTypeValues.reverse[mediaType],
        "original_language": originalLanguage != null ? originalLanguageValues.reverse[originalLanguage] : null,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "release_date": releaseDate != null
            ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
            : null,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

enum MediaType {
    MOVIE
}

final mediaTypeValues = EnumValues({
    "movie": MediaType.MOVIE
});

enum OriginalLanguage {
    DE,
    EN,
    FR
}

final originalLanguageValues = EnumValues({
    "de": OriginalLanguage.DE,
    "en": OriginalLanguage.EN,
    "fr": OriginalLanguage.FR
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
