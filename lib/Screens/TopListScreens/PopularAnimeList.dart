import 'package:anixon/Screens/MainScreens/detail.dart';
import 'package:anixon/services/anime_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class popularanime extends StatefulWidget {
  const popularanime({Key? key}) : super(key: key);

  @override
  State<popularanime> createState() => _popularanimeState();
}

class _popularanimeState extends State<popularanime> {
  List<dynamic> MostPopularAnimeList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final topAnimeData = await ApiService.fetchMostPopularAnimeData();
      setState(() {
        MostPopularAnimeList = topAnimeData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Anixon',
          style: GoogleFonts.caveat(
              fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 30),
        ),
      ),
      body: MostPopularAnimeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: MostPopularAnimeList.length > 50
                  ? 50
                  : MostPopularAnimeList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> animeData = MostPopularAnimeList[index];
                return Container(
                  height: MediaQuery.sizeOf(context).height / 4.2,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey.shade900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(
                                  8.0), // Optional: Set border radius
                              image: DecorationImage(
                                image: NetworkImage(animeData['picture_url']),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: screenWidth / 2,
                                child: Text(
                                  animeData['title'],
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 15,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                animeData['aired_on'],
                                style: GoogleFonts.ubuntu(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white60),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 70,
                            child: Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.leaderboard_outlined,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${animeData['rank']}',
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlueContainer("Type", animeData['type']),
                          Container(
                              padding:
                                  EdgeInsets.only(top: 7, bottom: 7, left: 7),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 11,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 5, right: 15),
                                    child: Text(
                                      '${animeData['score']}',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                          BlueContainer("Members", ' ${animeData['members']}')
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(Icons.info_outline, "See more", () { navigateToDetailScreen(
                              context, '${animeData['myanimelist_id']}');},
                              screenWidth, Colors.blue),
                          CustomButton(Icons.play_arrow_sharp, "Watch", () {},
                              screenWidth, Colors.black)
                        ],
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}

Widget CustomButton(IconData icon, String text, VoidCallback onPressed,
    double screenWidth, Color color) {
  return Container(
    child: Row(
      children: [
        SizedBox(
          height: 30,
          width: screenWidth / 2.3,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // Button color
              onPrimary: Colors.black, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Curved border
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget BlueContainer(String title, String value) {
  return Container(
    width: 120,
    padding: EdgeInsets.all(7.0),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.blue),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.ubuntu(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 11,
            fontWeight: FontWeight.w200,
            color: Colors.white,
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
