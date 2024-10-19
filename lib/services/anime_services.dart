import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://myanimelist.p.rapidapi.com';
  static const Map<String, String> headers = {
    'X-RapidAPI-Key': 'e3d6e32565msh0ede018c7f75b05p13f09ajsne76a1519419a',
    'X-RapidAPI-Host': 'myanimelist.p.rapidapi.com',
  };

  static Future<List<dynamic>> _fetchAnimeData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/anime/top/$endpoint'), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load anime data for endpoint: $endpoint');
    }
  }

  static Future<List<dynamic>> fetchTopAnimeData() async {
    return _fetchAnimeData('all');
  }

  static Future<List<dynamic>> fetchTopAiringAnimeData() async {
    return _fetchAnimeData('airing');
  }

  static Future<List<dynamic>> fetchTopMoviesAnimeData() async {
    return _fetchAnimeData('movie');
  }

  static Future<List<dynamic>> fetchMostPopularAnimeData() async {
    return _fetchAnimeData('bypopularity');
  }

  static Future<List<dynamic>> fetchMostFavoriteAnimeData() async {
    return _fetchAnimeData('favorite');
  }

  static Future<Map<String, dynamic>> fetchAnimeDetails(String animeId) async {
    final String apiUrl = '$baseUrl/anime/$animeId';
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load anime details');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSearchDetails(String query) async {
    final String apiUrl = '$baseUrl/v2/anime/search?q=$query&n=50&score=8';
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is List) {
        final List<Map<String, dynamic>> searchResults =
        responseData.cast<Map<String, dynamic>>();

        return searchResults;
      } else {
        throw Exception('Invalid response format: $responseData');
      }
    } else {
      throw Exception('Failed to load anime details');
    }
  }

}
