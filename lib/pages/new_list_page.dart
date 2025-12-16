import 'package:flutter/material.dart';
import '../models/new_article.dart';
import '../services/api.dart';
import '../widgets/news_items.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryNewsColor = Color(0xFFD84315); // Deep Orange A700

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Tin tức Kinh doanh", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryNewsColor,
        foregroundColor: Colors.white, 
        elevation: 1, // Giảm elevation
      ),

      body: FutureBuilder<List<NewsArticle>>(
        future: NewsApiService.fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryNewsColor));
          } 
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text("Không thể tải tin tức: ${snapshot.error}", textAlign: TextAlign.center),
                ],
              ),
            );
          } 
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có bài viết nào trong danh mục này"));
          } 
          else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return NewsItem(article: articles[index]);
              },
            );
          } 
        },
      ),
    );
  }
}