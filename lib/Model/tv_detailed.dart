class TvDetailed {
  final int id;
  final String name;
  final String? posterPath;
  final String? overview; // Nullable
  final DateTime firstAirDate;
  final int numberOfSeasons;

  TvDetailed({
    required this.id,
    required this.name,
    this.posterPath,
    this.overview,
    required this.firstAirDate,
    required this.numberOfSeasons,
  });

  factory TvDetailed.fromJson(Map<String, dynamic> json) => TvDetailed(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown TV Show",
        posterPath: json["poster_path"],
        overview: json["overview"],
        firstAirDate: json["first_air_date"] != null &&
                json["first_air_date"].isNotEmpty
            ? DateTime.tryParse(json["first_air_date"]) ?? DateTime(1970)
            : DateTime(1970),
        numberOfSeasons: json["number_of_seasons"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "poster_path": posterPath,
        "overview": overview,
        "first_air_date":
            "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "number_of_seasons": numberOfSeasons,
      };
}