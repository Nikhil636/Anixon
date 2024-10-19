import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter_quill/youtube_player_flutter_quill.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  final List<String> videoIds = [
    "VxlS7NBeHjw",
    "RLHlWePNU38",
    "TLFgoUTZfzk",
    "9IocdXdBj0o",
    "3w4ovPmOw78",
    "BjQLc2gR-2c",
    "Dhi0X_2Lkzk",
    "zIIqyDO0yDk",
    "Wt6TLqZXKr0",
    "FxlZJFRuL3I",
    "oJ8NC7oINgg",
    "qjvlBluhPaA"
  ];
  int currentVideoIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoIds[currentVideoIndex],
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }
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
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player initialized');
                },
                onEnded: (YoutubeMetaData metaData) {
                  print('Video ended');
                  // Handle video ended event here
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              child: Text(
                "Mushoku Tensei: Isekai Ittara Honki Dasu",
                style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Mushoku Tensei: Jobless Reincarnation",
                style: GoogleFonts.ubuntu(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ExpansionTile(
              backgroundColor: Colors.grey.shade900,
              collapsedBackgroundColor: Colors.grey.shade900,
              title: Text(
                'Episode  (${currentVideoIndex + 1}/12)',
                style: TextStyle(color: Colors.white),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: videoIds.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Colors.grey.shade800,
                        child: ListTile(
                          leading: Padding(
                            padding:
                                EdgeInsets.only(right: 8, top: 5, bottom: 5),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  "https://i0.wp.com/anitrendz.net/news/wp-content/uploads/2021/01/mushokutensei_poster-2-e1610014997207.jpg?resize=768%2C433&ssl=1",
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16.0,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            'Episode ${index + 1}',
                            style: GoogleFonts.playfairDisplay(
                                color: index == currentVideoIndex
                                    ? Colors.blue
                                    : Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            setState(() {
                              currentVideoIndex = index;
                              _controller.load(videoIds[currentVideoIndex]);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
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
            SizedBox(
              height: 15,
            ),
            ExpandableText(
              "Despite being bullied, scorned, and oppressed all of his life, a 34-year-old shut-in still found the resolve to attempt something heroic—only for it to end in a tragic accident. But in a twist of fate, he awakens in another world as Rudeus Greyrat, starting life again as a baby born to two loving parents. \n \n Preserving his memories and knowledge from his previous life, Rudeus quickly adapts to his new environment. With the mind of a grown adult, he starts to display magical talent that exceeds all expectations, honing his skill with the help of a mage named Roxy Migurdia. Rudeus learns swordplay from his father, Paul, and meets Sylphiette, a girl his age who quickly becomes his closest friend.\n \n  As Rudeus' second chance at life begins, he tries to make the most of his new opportunity while conquering his traumatic past. And perhaps, one day, he may find the one thing he could not find in his old world—love.\n \n [Written by MAL Rewrite]",
              expandText: 'See more',
              collapseText: 'See less',
              maxLines: 5,
              linkColor: Colors.blue,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
