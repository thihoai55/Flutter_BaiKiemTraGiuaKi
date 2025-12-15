// file: new_detail_page.dart (Đã sửa đổi để hiển thị Tác giả và Nội dung chi tiết)

import 'package:flutter/material.dart';
import '../models/new_article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    const Color primaryNewsColor = Color(0xFFD84315); // Deep Orange
    
    // Định dạng ngày tháng
    String formattedDate = '';
    try {
      final date = DateTime.parse(article.publishedAt);
      formattedDate = "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      formattedDate = article.publishedAt.split('T').first;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Nền xám nhạt
      appBar: AppBar(
        title: const Text("Chi tiết Bài báo"),
        backgroundColor: primaryNewsColor,
        foregroundColor: Colors.white,
        elevation: 0, 
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 1. CARD CHỨA ẢNH & TIÊU ĐỀ
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ẢNH BÀI BÁO (Bên trong Card)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: (article.imageUrl.isNotEmpty)
                        ? Image.network(
                            article.imageUrl,
                            height: 200, 
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'asset/image.jpg',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'asset/image.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),

                  // TIÊU ĐỀ & NGUỒN (Bên dưới ảnh trong Card)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Thông tin Tác giả mới
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.sourceName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: primaryNewsColor,
                                ),
                              ),
                              if (article.author != null && article.author!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Tác giả: ${article.author}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Ngày xuất bản
                        Text(
                          'Xuất bản: $formattedDate',
                          style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // 2. NỘI DUNG CHÍNH (Được tách biệt khỏi Card Ảnh)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // MÔ TẢ NGẮN (Description)
                  const Text(
                    "Tóm tắt Mô tả:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 10, thickness: 1.5, color: Colors.grey),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    article.description,
                    style: const TextStyle(
                      fontSize: 17, 
                      height: 1.6, 
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  
                  const SizedBox(height: 30),

                  // NỘI DUNG CHI TIẾT (Content)
                  if (article.content != null && article.content!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nội dung chi tiết (Trích đoạn):",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Divider(height: 10, thickness: 1.5, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          article.content!,
                          style: const TextStyle(
                            fontSize: 17, 
                            height: 1.6, 
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 40),

                  // NÚT ĐỌC BÀI ĐẦY ĐỦ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(article.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Không thể mở liên kết này')),
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new, color: Colors.white, size: 28),
                      label: const Text(
                        "ĐỌC BÀI ĐẦY ĐỦ TRÊN WEB",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNewsColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}