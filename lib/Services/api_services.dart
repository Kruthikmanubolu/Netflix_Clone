import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netflix_clone/Common/utils.dart';
import 'package:netflix_clone/Model/movie_detailed.dart';
import 'package:netflix_clone/Model/movie_model.dart';
import 'package:netflix_clone/Model/movie_recommendations.dart';
import 'package:netflix_clone/Model/popular_tv_series.dart';
import 'package:netflix_clone/Model/search_multi.dart';
import 'package:netflix_clone/Model/tmdb_trending.dart';
import 'package:netflix_clone/Model/top_rated_movie.dart';
import 'package:netflix_clone/Model/trending_movie_model.dart';
import 'package:netflix_clone/Model/tv_detailed.dart';
import 'package:netflix_clone/Model/tv_recommendations.dart';
import 'package:netflix_clone/Model/upcoming_movie_model.dart';

var key = '?api_key=$apiKey';

class ApiServices {
  Future<Movie?> fetchMovies() async {
    try {
      const endPoint = "/movie/now_playing";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return Movie.fromJson(jsonDecode(response.body));
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      print('error fetching movies: $e');
      throw Exception('Failed to load movies');
    }
  }

  Future<UpcomingMovies?> upComingMovies() async {
    try {
      const endPoint = "/movie/upcoming";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling Upcoming Movies API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Upcoming Movies Response status: ${response.statusCode}");
      print("Upcoming Movies Response body: ${response.body}");

      if (response.statusCode == 200) {
        return UpcomingMovies.fromJson(jsonDecode(response.body));
      } else {
        print('Upcoming Movies failed with status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load upcoming movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      rethrow;
    }
  }

  Future<TopRated?> topRatedMovies() async {
    try {
      const endPoint = "/movie/top_rated";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling Top Rated Movies API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Top Rated Movies Response status: ${response.statusCode}");
      print("Top Rated Movies Response body: ${response.body}");

      if (response.statusCode == 200) {
        return TopRated.fromJson(jsonDecode(response.body));
      } else {
        print('Top Rated Movies failed with status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load top rated movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching top rated movies: $e');
      rethrow;
    }
  }

  Future<TrendingMovies?> trendingMovies() async {
    try {
      const endPoint = "/trending/movie/day";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling Trending Movies API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Trending Movies Response status: ${response.statusCode}");
      print("Trending Movies Response body: ${response.body}");

      if (response.statusCode == 200) {
        return TrendingMovies.fromJson(jsonDecode(response.body));
      } else {
        print('Trending Movies failed with status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load trending movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching trending movies: $e');
      rethrow;
    }
  }

  Future<PopularTvSeries?> popularTvSeries() async {
    try {
      const endPoint = "/tv/popular";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return PopularTvSeries.fromJson(jsonDecode(response.body));
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      print('error fetching movies: $e');
      throw Exception('Failed to load movies');
    }
  }

  Future<MovieDetailed?> movieDetailed(int movieId) async {
    try {
      final endPoint = "/movie/$movieId";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling Movie Detailed API for ID $movieId: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Movie Detailed Response status: ${response.statusCode}");
      print("Movie Detailed Response body: ${response.body}");

      if (response.statusCode == 200) {
        return MovieDetailed.fromJson(jsonDecode(response.body));
      } else {
        print('Movie Detailed failed with status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movie details for ID $movieId: $e');
      rethrow;
    }
  }

  Future<MovieRecommendations?> movieRecommendation(int movieId) async {
    try {
      final endPoint = "/movie/$movieId/recommendations";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final movieRecommendations = MovieRecommendations.fromJson(
          jsonDecode(response.body),
        );
        print("Recommendations count: ${movieRecommendations.results.length}");
        return movieRecommendations;
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      throw Exception('Failed to load recommendations');
    }
  }

  Future<TvDetailed?> tvDetailed(int tvId) async {
    try {
      final endPoint = "/tv/$tvId";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return TvDetailed.fromJson(jsonDecode(response.body));
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load TV show: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching TV show: $e');
      rethrow;
    }
  }

  Future<TvRecommendations?> tvRecommendation(int tvId) async {
    try {
      final endPoint = "/tv/$tvId/recommendations";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return TvRecommendations.fromJson(jsonDecode(response.body));
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load TV recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching TV recommendations: $e');
      rethrow;
    }
  }

  static Future<List<SearchMultiResult>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = searchMultiFromJson(response.body);
      // Filter only movies
      final filteredResults = data.results
          .where((item) => item.mediaType == 'movie')
          .toList();
      return filteredResults;
    } else {
      throw Exception('Failed to fetch trending movies');
    }
  }

  // Your existing searchMulti method remains unchanged
  static Future<List<SearchMultiResult>> searchMulti(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/multi?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = searchMultiFromJson(response.body);
      final filteredResults = data.results
          .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
          .toList();
      return filteredResults;
    } else {
      throw Exception('Failed to search multi');
    }
  }

  Future<TmdbTrending?> tmdbTrending(int tvId) async {
    try {
      final endPoint = "/trending/all/day";
      final apiUrl = "$baseUrl$endPoint$key";

      print("Calling API: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return TmdbTrending.fromJson(jsonDecode(response.body));
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
          'Failed to load TV recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching TV recommendations: $e');
      rethrow;
    }
  }
}
