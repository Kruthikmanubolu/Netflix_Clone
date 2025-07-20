import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:netflix_clone/Model/tmdb_trending.dart';
import 'package:netflix_clone/Services/api_services.dart';

class HotNewScreen extends StatefulWidget {
  const HotNewScreen({super.key});

  @override
  State<HotNewScreen> createState() => _HotNewScreenState();
}

class _HotNewScreenState extends State<HotNewScreen> {
  TmdbTrending? trending;

  @override
  void initState() {
    super.initState();
    loadTrending();
  }

  Future<void> loadTrending() async {
    final result = await ApiServices().tmdbTrending(
      0,
    ); // 0 used as dummy, not needed in this case
    setState(() {
      trending = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Hot News"),
        centerTitle: true,
      ),
      body: trending == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: trending!.results.length,
              itemBuilder: (context, index) {
                final item = trending!.results[index];
                final parsedDate = item.releaseDate ?? item.firstAirDate;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: parsedDate != null
                          ? Column(
                              children: [
                                Text(
                                  DateFormat.d().format(parsedDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  DateFormat.MMM().format(parsedDate),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${item.backdropPath}',
                            placeholder: (context, url) => const SizedBox(
                              height: 180,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      parsedDate != null
                                          ? "Coming on ${DateFormat.d().add_MMM().format(parsedDate)}"
                                          : "Coming Soon",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.notifications_none,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.overview,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
