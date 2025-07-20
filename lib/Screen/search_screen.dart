import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_clone/Model/search_multi.dart';
import 'package:netflix_clone/Services/api_services.dart';
import 'package:netflix_clone/Screen/movie_detailed_screen.dart';
import 'package:netflix_clone/Screen/tv_detailed_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<SearchMultiResult> _results = [];
  bool _isLoading = false;
  bool _isShowingTrending = true; // New flag to track trending movies state
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Fetch trending movies when the screen loads
    _fetchTrendingMovies();
  }

  void _fetchTrendingMovies() async {
    setState(() {
      _isLoading = true;
      _isShowingTrending = true; // Set flag to true when fetching trending movies
    });

    try {
      final trendingMovies = await ApiServices.getTrendingMovies();
      setState(() {
        _results = trendingMovies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load trending movies: $e')),
      );
    }
  }

  void _search(String query) async {
    if (query.trim().isEmpty) {
      // When search is cleared, show trending movies again
      _fetchTrendingMovies();
      return;
    }

    setState(() {
      _isLoading = true;
      _isShowingTrending = false; // Set to false when searching
    });

    try {
      final results = await ApiServices.searchMulti(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search: $e')),
      );
    }
  }

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(query);
    });
  }

  void _onResultTap(SearchMultiResult result) {
    if (result.mediaType == 'movie') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailedScreen(movieId: result.id),
        ),
      );
    } else if (result.mediaType == 'tv') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TvDetailedScreen(tvId: result.id),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Search games, shows, movies...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: const Icon(Icons.mic, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Add spacing for better visibility
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_results.isEmpty && !_isShowingTrending)
            const Expanded(
              child: Center(
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isShowingTrending && _results.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'Top Searches',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final result = _results[index];
                        return ListTile(
                          onTap: () => _onResultTap(result),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          leading: result.posterPath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w200${result.posterPath}',
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: 70,
                                  height: 100,
                                  color: Colors.grey,
                                  child: const Icon(Icons.movie),
                                ),
                          title: Text(
                            result.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}