import 'dart:convert';

SearchMulti searchMultiFromJson(String str) =>
    SearchMulti.fromJson(json.decode(str));

String searchMultiToJson(SearchMulti data) => json.encode(data.toJson());

class SearchMulti {
  final int page;
  final List<SearchMultiResult> results;
  final int totalPages;
  final int totalResults;

  SearchMulti({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchMulti.fromJson(Map<String, dynamic> json) => SearchMulti(
        page: json["page"],
        results: List<SearchMultiResult>.from(
          json["results"]
              .map((x) => SearchMultiResult.fromJson(x))
              .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv'),
        ),
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

class SearchMultiResult {
  final int id;
  final String mediaType; // "movie" or "tv"
  final String title;
  final String? posterPath;
  final String? overview;

  SearchMultiResult({
    required this.id,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.overview,
  });

  factory SearchMultiResult.fromJson(Map<String, dynamic> json) {
    String resolvedTitle = json["title"] ?? json["name"] ?? 'No Title';

    return SearchMultiResult(
      id: json["id"],
      mediaType: json["media_type"],
      title: resolvedTitle,
      posterPath: json["poster_path"],
      overview: json["overview"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_type": mediaType,
        "title": title,
        "poster_path": posterPath,
        "overview": overview,
      };
}
