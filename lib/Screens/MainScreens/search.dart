import 'dart:convert';

import 'package:anixon/Screens/MainScreens/detail.dart';
import 'package:anixon/services/anime_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchData('');
  }

  Future<void> fetchData(String value) async {
    try {
      final searchData = await ApiService.fetchSearchDetails(value);
      if (searchData != null) {
        setState(() {
          searchResults = searchData;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              "Find your favorite anime",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 25,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 17,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for anime...',
                  filled: true,
                  fillColor: Colors.white, // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Image.asset(
                    'assets/icons/textfieldsearch.png',
                    color: Colors.black,
                    width: 5.0,
                    height: 5.0,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    fetchData(value);
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.height / 20,
              child: ElevatedButton(
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    fetchData(_searchController.text);
                  }
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            searchResults == null || searchResults.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'Explore and stream your favorite anime series and movies!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            if (searchResults[index] != null) {
                              final result = searchResults[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    navigateToDetailScreen(
                                        context,  '${result['myanimelist_id']}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  result['picture_url'] ?? ''),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                10), // Adjust the spacing between image and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                result['title'] ?? 'Unknown',
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height:
                                                      5), // Add some vertical spacing
                                              Text(
                                                result['description'] ?? '',
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                        fontSize: 10,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

void navigateToDetailScreen(BuildContext context, String animeId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AnimeDetailScreen(animeId: animeId),
    ),
  );
}
