import 'package:anixon/Screens/MainScreens/home.dart';
import 'package:anixon/services/anime_services.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String animeId;
  const AnimeDetailScreen({Key? key, required this.animeId}) : super(key: key);

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  Map<String, dynamic> animeDetails = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final selectedAnimeDetails =
          await ApiService.fetchAnimeDetails(widget.animeId);

      setState(() {
        animeDetails = selectedAnimeDetails;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
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
      body: animeDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          animeDetails['picture_url'] ?? '',
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 6.5,
                          left: MediaQuery.of(context).size.width / 3,
                          child: GestureDetector(
                            onTap: (){navigateVideoPlayer(context);},
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(12.0), // Increase the padding for a larger button
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue,
                                size: 62.0, // Increase the size for a larger button
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animeDetails['title_ov'],
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            animeDetails['alternative_titles']['english'] ?? '',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 15,
                                color: Colors.white70,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildStatisticContainer('Popularity',
                              '${animeDetails['statistics']['popularity']}'),
                          SizedBox(height: 10),
                          buildStatisticContainer('Favorites',
                              '${animeDetails['statistics']['favorites']}'),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildStatisticContainer('Members',
                              '${animeDetails['statistics']['members']}'),
                          SizedBox(height: 10),
                          buildStatisticContainer('Ranked',
                              '${animeDetails['statistics']['ranked']}'),
                        ],
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${animeDetails['statistics']['score']}',
                              style: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.white70,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow('Type: ',
                          '${animeDetails['information']['type'][0]['name']}'),
                      buildRow('Genre: ',
                          '${animeDetails['information']['genres'].map((genre) => genre['name']).join(', ')}'),
                      buildRow('Studio: ',
                          ' ${animeDetails['information']['studios'][0]['name']}'),
                      buildRow('Airing Date: ',
                          ' ${animeDetails['information']['aired']}'),
                      buildRow('Status: ',
                          ' ${animeDetails['information']['status']}'),
                      buildRow('Episodes: ',
                          ' ${animeDetails['information']['episodes']}'),
                      buildRow('Duration: ',
                          ' ${animeDetails['information']['duration']}'),
                      buildRow('Rating: ',
                          ' ${animeDetails['information']['rating']}'),
                      buildRow('Source: ',
                          ' ${animeDetails['information']['source']}'),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Divider(
                    color: Colors.white70,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Synopsis",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ExpandableText(
                    animeDetails['synopsis'],
                    expandText: 'See more',
                    collapseText: 'See less',
                    maxLines: 5,
                    linkColor: Colors.blue,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Colors.white70,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.person_2_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Characters",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 130, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: animeDetails['characters'].length,
                      itemBuilder: (context, index) {
                        var character = animeDetails['characters'][index];
                        return Container(
                          color: Colors.grey.shade900,
                          width: 80,
                          padding: EdgeInsets.only(top: 8),
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    image:
                                        NetworkImage(character['picture_url']),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    character['name'],
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 10,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget buildStatisticContainer(String title, String value) {
  return Container(
    width: 110,
    padding: EdgeInsets.all(8.0),
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
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 10,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget buildRow(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        buildText(title, Colors.blue, letterSpacing: 1.5),
        buildText(content, Colors.white),
      ],
    ),
  );
}

Widget buildText(String text, Color color, {double letterSpacing = 0.0}) {
  return Expanded(
    child: Text(
      text,
      style: GoogleFonts.ubuntu(
        letterSpacing: letterSpacing,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    ),
  );
}
