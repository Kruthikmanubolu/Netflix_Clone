import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/Common/utils.dart';
import 'package:netflix_clone/Model/movie_model.dart';
import 'package:netflix_clone/Model/popular_tv_series.dart';
import 'package:netflix_clone/Model/top_rated_movie.dart';
import 'package:netflix_clone/Model/trending_movie_model.dart';
import 'package:netflix_clone/Model/upcoming_movie_model.dart';
import 'package:netflix_clone/Screen/movie_detailed_screen.dart';
import 'package:netflix_clone/Screen/search_screen.dart';
import 'package:netflix_clone/Screen/tv_detailed_screen.dart';
import 'package:netflix_clone/Screen/video_screen.dart';
import 'package:netflix_clone/Services/api_services.dart';

class NetflixHomeScreen extends StatefulWidget {
  const NetflixHomeScreen({super.key});

  @override
  State<NetflixHomeScreen> createState() => _NetflixHomeScreenState();
}

class _NetflixHomeScreenState extends State<NetflixHomeScreen> {
  final ApiServices apiServices = ApiServices();
  late Future<Movie?> movieData;
  late Future<UpcomingMovies?> upcomingMovies;
  late Future<TopRated?> topRatedMovies;
  late Future<TrendingMovies?> trendingMovies;
  late Future<PopularTvSeries?> popularTvSeries;

  @override
  void initState() {
    movieData = apiServices.fetchMovies();
    upcomingMovies = apiServices.upComingMovies();
    topRatedMovies = apiServices.topRatedMovies();
    trendingMovies = apiServices.trendingMovies();
    popularTvSeries = apiServices.popularTvSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/logo.jpg", height: 50),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  const Icon(
                    Icons.download_sharp,
                    size: 27,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.cast, size: 27, color: Colors.white),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white38),
                    ),
                    child: const Text(
                      'TV Shows',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white38),
                    ),
                    child: const Text(
                      'Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white38),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 530,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: FutureBuilder(
                      future: movieData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final movies = snapshot.data!.results;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView.builder(
                              itemCount: movies.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailedScreen(
                                              movieId: movie.id,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 530,
                                    width: 388,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          "$imageUrl${movie.posterPath}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("Problem to fetch data"),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NetflixStylePlayer(
                                      videoUrl:
                                          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Play",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  Text(
                                    "My List",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // ... other parts of the build method ...
            moviesTypes(
              future: trendingMovies,
              movieType: 'Trending Movies on Netflix',
              contentType: 'movie',
            ),
            moviesTypes(
              future: upcomingMovies,
              movieType: 'Upcoming Movies',
              contentType: 'movie',
            ),
            moviesTypes(
              future: popularTvSeries,
              movieType: 'Popular TV Series - Must-Watch For You',
              contentType: 'tv',
            ),
            moviesTypes(
              future: topRatedMovies,
              movieType: 'Top Rated Movies',
              contentType: 'movie',
            ),
          ],
        ),
      ),
    );
  }

  Padding moviesTypes({
    required Future future,
    required String movieType,
    required String contentType,
    bool isReverse = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 180,
            width: double.maxFinite,
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error in $movieType: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!.results;
                  // Filter for movies if contentType is 'movie'
                  final filteredMovies = contentType == 'movie'
                      ? movies.where(
                          (item) =>
                              item.mediaType == null ||
                              item.mediaType == 'movie',
                        )
                      : movies;
                  if (filteredMovies.isEmpty) {
                    return const Center(child: Text('No items available'));
                  }
                  return ListView.builder(
                    itemCount: filteredMovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = filteredMovies.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            print('Navigating to $contentType ID: ${item.id}');
                            if (contentType == 'tv') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TvDetailedScreen(tvId: item.id),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailedScreen(movieId: item.id),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 180,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  item.posterPath != null
                                      ? "$imageUrl${item.posterPath}"
                                      : 'https://via.placeholder.com/150',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Problem to fetch data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
