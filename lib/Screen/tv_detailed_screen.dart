import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/Common/utils.dart';
import 'package:netflix_clone/Model/tv_detailed.dart';
import 'package:netflix_clone/Model/tv_recommendations.dart';
import 'package:netflix_clone/Services/api_services.dart';

class TvDetailedScreen extends StatefulWidget {
  final int tvId;

  const TvDetailedScreen({super.key, required this.tvId});

  @override
  State<TvDetailedScreen> createState() => _TvDetailedScreenState();
}

class _TvDetailedScreenState extends State<TvDetailedScreen> {
  final ApiServices apiServices = ApiServices();
  late Future<TvDetailed?> tvDetailed;
  late Future<TvRecommendations?> tvRecommendation;

  @override
  void initState() {
    super.initState();
    tvDetailed = apiServices.tvDetailed(widget.tvId);
    tvRecommendation = apiServices.tvRecommendation(widget.tvId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<TvDetailed?>(
        future: tvDetailed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final tv = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster with overlay play button, title, and top actions
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              tv.posterPath != null
                                  ? '$imageUrl${tv.posterPath}'
                                  : 'https://via.placeholder.com/150', // Fallback image
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.download_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.15),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 64,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Text(
                          tv.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Metadata
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          '${tv.firstAirDate.year}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "TV-MA",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${tv.numberOfSeasons} Season${tv.numberOfSeasons > 1 ? 's' : ''}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      tv.overview ?? 'No overview available',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // My List | Rate | Share
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _ActionButton(icon: Icons.add, label: "My List"),
                        _ActionButton(
                          icon: Icons.thumb_up_alt_outlined,
                          label: "Rate",
                        ),
                        _ActionButton(icon: Icons.share, label: "Share"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Recommendations
                  FutureBuilder(
                    future: tvRecommendation,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Recommendation error: ${snapshot.error}');
                        return const Center(
                          child: Text(
                            'Failed to load recommendations',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final tvRecs = snapshot.data!;
                        if (tvRecs.results.isEmpty) {
                          print('No recommendations available');
                          return const SizedBox();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'More Like This',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: tvRecs.results.length,
                                itemBuilder: (context, index) {
                                  final posterPath = tvRecs.results[index].posterPath;
                                  if (posterPath == null) {
                                    return const SizedBox(width: 150);
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CachedNetworkImage(
                                      imageUrl: '$imageUrl$posterPath',
                                      height: 200,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: Text(
                          'No recommendations data',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No TV show data found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}