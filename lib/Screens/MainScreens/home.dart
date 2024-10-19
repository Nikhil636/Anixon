import 'dart:convert';
import 'package:anixon/Screens/MainScreens/detail.dart';
import 'package:anixon/Screens/MainScreens/videoplayer.dart';
import 'package:anixon/Screens/TopListScreens/AiringList.dart';
import 'package:anixon/Screens/TopListScreens/FavoriteAnimeList.dart';
import 'package:anixon/Screens/TopListScreens/PopularAnimeList.dart';
import 'package:anixon/Screens/TopListScreens/TopMovies.dart';
import 'package:anixon/Screens/bottomnavbar.dart';
import 'package:anixon/services/anime_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late final User user;
  List<dynamic> topAnimeList = [];
  List<dynamic> topAiringAnimeList = [];
  List<dynamic> topMovieList = [];
  List<dynamic> MostPopularAnimeList = [];
  List<dynamic> MostFavoriteAnimeList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final topAnimeData = await ApiService.fetchTopAnimeData();
      final topAiringAnimeData = await ApiService.fetchTopAiringAnimeData();
      final topMovieData = await ApiService.fetchTopMoviesAnimeData();
      final MostPopularAnimeData = await ApiService.fetchMostPopularAnimeData();
      final MostFavoriteAnimeData =
          await ApiService.fetchMostFavoriteAnimeData();
      setState(() {
        topAnimeList = topAnimeData;
        topAiringAnimeList = topAiringAnimeData;
        topMovieList = topMovieData;
        MostPopularAnimeList = MostPopularAnimeData;
        MostFavoriteAnimeList = MostFavoriteAnimeData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnimeCarousel(
                'Top Anime', topAnimeList, screenHeight, screenWidth),
            SizedBox(height: 15),
            AiringAnimeList(context,'Top Airing Anime', topAiringAnimeList,
                screenHeight, screenWidth),
            SizedBox(height: 15),
            AnimeMovieList(context,
                'Top Anime Movie', topMovieList, screenHeight, screenWidth),
            SizedBox(height: 15),
            PopularAnimeList(context,'Most Popular Anime', MostPopularAnimeList,
                screenHeight, screenWidth),
            SizedBox(height: 15),
            FavoriteAnimeList(context,'Most Favorite Anime', MostFavoriteAnimeList,
                screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }
}

Widget _buildAnimeCarousel(String title, List<dynamic> animeList,
    double screenHeight, double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: screenHeight / 3.35,
        width: screenWidth, // Adjust the height as needed
        child: animeList.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CarouselSlider.builder(
                itemCount: animeList.length,
                itemBuilder: (context, index, realIndex) {
                  final anime = animeList[index];
                  return buildAnimeCarouselItem(
                     context, anime, screenHeight, screenWidth,);
                },
                options: CarouselOptions(
                  aspectRatio: 3 / 4,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
      ),
    ],
  );
}

Widget buildAnimeCarouselItem(
    BuildContext context,
  Map<String, dynamic> animeData,
  double screenHeight,
  double screenWidth,
) {
  return GestureDetector(
    onTap: (){
    },
    child: Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Colors.grey.shade900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional: Set border radius
                  image: DecorationImage(
                    image: NetworkImage(animeData['picture_url']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 8),
                height: 70,
                width: screenWidth / 2.1,
                child: Text(
                  animeData['title'],
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            animeData['type'],
            style: GoogleFonts.ubuntu(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.white60),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            animeData['aired_on'],
            style: GoogleFonts.ubuntu(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.white60),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${animeData['members']} members',
            style: GoogleFonts.ubuntu(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.white60),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 15),
                      child: Text(
                        '${animeData['score']}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: 30,
                      width: screenWidth / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          navigateVideoPlayer(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Button color
                          onPrimary: Colors.black, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Curved border
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow_sharp,
                              color: Colors.black,
                            ),
                            Text(
                              'Watch',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
Widget AiringAnimeList(
    BuildContext context,
    String title,
    List<dynamic> animeList,
    double screenHeight,
    double screenWidth,
    ) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () {
                  navigateToTopAiring(context);
                },
                child: Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          height: 170,
          child: animeList.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];
              return GestureDetector(
                onTap: () {
                  navigateToDetailScreen(
                      context, '${anime['myanimelist_id']}');
                },
                child: Container(
                  color: Colors.grey.shade900,
                  width: 100,
                  padding: EdgeInsets.only(top: 10),
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(
                              8.0), // Optional: Set border radius
                          image: DecorationImage(
                            image: NetworkImage(anime['picture_url']),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          anime['title'],
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 10,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 10, left: 15, right: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 15,
                            ),
                            Text(
                              '${anime['score']} (MAL)',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white60),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget AnimeMovieList(
    BuildContext context,
    String title, List<dynamic> animeList,

    double screenHeight, double screenWidth) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextButton(
                  onPressed: () {navigateToTopRatedMovies(context);},
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
        Container(
          height: 170,
          child: animeList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: animeList.length,
                  itemBuilder: (context, index) {
                    final anime = animeList[index];
                    return GestureDetector(
                      onTap: (){ navigateToDetailScreen(
                          context, '${anime['myanimelist_id']}');},
                      child: Container(
                        color: Colors.grey.shade900,
                        width: 100,
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Optional: Set border radius
                                image: DecorationImage(
                                  image: NetworkImage(anime['picture_url']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                anime['title'],
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 10,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 15, right: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 15,
                                  ),
                                  Text(
                                    '${anime['score']} (MAL)',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white60),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

Widget PopularAnimeList(
    BuildContext context,
    String title, List<dynamic> animeList,
    double screenHeight, double screenWidth) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextButton(
                  onPressed: () {navigateToMostPopularAnime(context);},
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
        Container(
          height: 170,
          child: animeList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: animeList.length,
                  itemBuilder: (context, index) {
                    final anime = animeList[index];
                    return GestureDetector(
                      onTap: (){ navigateToDetailScreen(
                          context, '${anime['myanimelist_id']}');},
                      child: Container(
                        color: Colors.grey.shade900,
                        width: 100,
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Optional: Set border radius
                                image: DecorationImage(
                                  image: NetworkImage(anime['picture_url']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                anime['title'],
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 10,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Text(
                                '${anime['members']} members',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white60),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

Widget FavoriteAnimeList(
    BuildContext context,String title, List<dynamic> animeList,
    double screenHeight, double screenWidth) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextButton(
                  onPressed: () {navigateToMostFavoriteAnime(context);},
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
        Container(
          height: 170,
          child: animeList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: animeList.length,
                  itemBuilder: (context, index) {
                    final anime = animeList[index];
                    return GestureDetector(
                      onTap: (){ navigateToDetailScreen(
                          context, '${anime['myanimelist_id']}');},
                      child: Container(
                        color: Colors.grey.shade900,
                        width: 100,
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Optional: Set border radius
                                image: DecorationImage(
                                  image: NetworkImage(anime['picture_url']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                anime['title'],
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 10,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Text(
                                '${anime['members']} favorites',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white60),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

void navigateToDetailScreen(BuildContext context, String animeId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AnimeDetailScreen(animeId: animeId),
    ),
  );
}

void navigateToTopAiring(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => topairing()),
  );
}

void navigateToTopRatedMovies(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => topmovies()),
  );
}

void navigateToMostPopularAnime(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => popularanime()),
  );
}

void navigateToMostFavoriteAnime(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => favoriteanime()),
  );
}
void navigateVideoPlayer(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => VideoPlayer()),
  );
}