import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/new_article.dart';

class NewsApiService {
  static const String apiKey = "6d53d16f4f8c40af8701980232b23394";
  static const String url =
      "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey";

  static Future<List<NewsArticle>> fetchNews() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}
