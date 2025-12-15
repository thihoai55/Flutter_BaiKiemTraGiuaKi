import 'package:flutter/material.dart';
import '../models/new_article.dart';
import '../pages/new_detail_page.dart';

class NewsItem extends StatelessWidget {
  final NewsArticle article;

  const NewsItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailPage(article: article)),
        );
      },
      child: Card(
        elevation: 5, // Tăng nhẹ đổ bóng
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ẢNH BÀI BÁO
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: (article.imageUrl.isNotEmpty)
                  ? Image.network(
                      article.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'asset/image.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'asset/image.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(15), // Tăng padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17, // Tăng kích thước tiêu đề
                      fontWeight: FontWeight.w800, // Đậm hơn
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.sourceName,
                        style: TextStyle(fontSize: 13, color: Colors.deepOrange.shade700, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        article.publishedAt.split('T').first,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}