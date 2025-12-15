// file: new_article.dart (Đã sửa đổi)

class NewsArticle {
  final String title;
  final String? author; // Thêm trường Tác giả
  final String description;
  final String? content; // Thêm trường Nội dung chi tiết
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String sourceName;

  NewsArticle({
    required this.title,
    this.author,
    required this.description,
    this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? "Không có tiêu đề",
      author: json['author'], // Lấy Tác giả
      description: json['description'] ?? "Không có mô tả",
      content: json['content'], // Lấy Nội dung chi tiết
      url: json['url'] ?? "",
      imageUrl: json['urlToImage'] ?? "",
      publishedAt: json['publishedAt'] ?? "",
      sourceName: json['source']['name'] ?? "Không rõ nguồn",
    );
  }
}