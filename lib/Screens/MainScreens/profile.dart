import 'package:anixon/Screens/MainScreens/home.dart';
import 'package:anixon/Screens/MainScreens/login.dart';
import 'package:anixon/services/anime_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> MostFavoriteAnimeList = [];
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await _getCurrentUser();
      final MostFavoriteAnimeData = await ApiService.fetchMostFavoriteAnimeData();

      setState(() {
        MostFavoriteAnimeList = MostFavoriteAnimeData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _getCurrentUser(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.black45,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          "https://www.108themes.com/night-scenery-anime/slider/2.jpg",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: _currentUser?.photoURL != null
                                ? NetworkImage(_currentUser!.photoURL!)
                                : AssetImage('assets/icons/profile.png') as ImageProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _currentUser?.displayName ?? 'Error fetching username',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 19),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomWidget('Followers', '56'),
                        CustomWidget('Anime Watched', '100'),
                        CustomWidget('Following', '50'),
                      ],
                    ),
                  ),
                  SizedBox(height: 19),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon('assets/icons/facebook.png'),
                      SizedBox(width: 20),
                      SocialIcon('assets/icons/twitter.png'),
                      SizedBox(width: 20),
                      SocialIcon('assets/icons/instagram.png'),
                    ],
                  ),
                  FavoriteAnimeList(context, 'Favorite', MostFavoriteAnimeList,
                      screenHeight, screenWidth),
                  SizedBox(
                    width: screenWidth / 2,
                    child: ElevatedButton(
                      onPressed: _handleSignOut,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget CustomWidget(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget SocialIcon(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.grey.shade900,
      ),
      padding: EdgeInsets.all(8),
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: Colors.white,
      ),
    );
  }

  Widget FavoriteAnimeList(BuildContext context, String title,
      List<dynamic> animeList, double screenHeight, double screenWidth) {
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
                    navigateToMostFavoriteAnime(context);
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            '${anime['members']} favorites',
                            style: GoogleFonts.ubuntu(
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            ),
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

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
