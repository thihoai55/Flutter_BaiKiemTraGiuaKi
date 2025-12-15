import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class SimpleHomePage extends StatelessWidget {
  const SimpleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Định nghĩa màu sắc thương hiệu
    const primaryColor = Color(0xFF1E88E5); // Màu xanh dương đậm
    const accentColor = Colors.indigo;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          "Tổng Kết Học Kỳ và Lời Tri Ân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TIÊU ĐỀ LỚN ---
            Center(
              child: Text(
                "Hành Trình Chinh Phục Lập Trình Di Động (Flutter)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3, color: Colors.amber),
            const SizedBox(height: 20),

            // --- QUÁ TRÌNH HỌC TẬP ---
            _buildSectionTitle(context, "I. Tóm Tắt Quá Trình Học Tập", Icons.history),
            _buildTextBlock(
              "Học kỳ vừa qua với môn Lập trình Di động (Flutter) thực sự là một trải nghiệm đầy thử thách và vô cùng quý giá. Từ những buổi làm quen với cú pháp Dart, cấu trúc Widget cơ bản (Stateless và Stateful) , đến việc xây dựng các ứng dụng phức tạp hơn như tính toán BMI, quản lý trạng thái, và tích hợp API xác thực người dùng.",
            ),
            _buildTextBlock(
              "Em đã được tiếp cận và thực hành các kiến thức trọng tâm:",
            ),
            _buildBulletPoint("Nắm vững các Widget cơ bản và layout linh hoạt (Buổi 3, 4)."),
            _buildBulletPoint("Áp dụng quản lý trạng thái cơ bản thông qua các ví dụ như Đếm số và Bộ đếm thời gian."),
            _buildBulletPoint("Triển khai các màn hình phức tạp như Đăng nhập/Đăng ký và Trang hồ sơ người dùng."),
            _buildBulletPoint("Thử nghiệm quy trình thanh toán (Checkout) và lưu trữ hóa đơn cục bộ (SharedPreferences)."),
            _buildBulletPoint("Tích hợp và xử lý dữ liệu từ API bên ngoài để xây dựng các tính năng thực tế."),
            const SizedBox(height: 30),

            // --- LỜI TRI ÂN GIẢNG VIÊN ---
            _buildSectionTitle(context, "II. Lời Tri Ân Sâu Sắc", Icons.favorite),
            _buildTextBlock(
              "Qua đây, Em xin gửi lời cảm ơn chân thành nhất đến Thầy Nguyễn Dũng người đã dẫn dắt Em trong suốt hành trình này.",
            ),
            _buildTextBlock(
              "Sự nhiệt tình, chuyên môn vững vàng và phương pháp giảng dạy rõ ràng của Thầy không chỉ giúp Em hiểu sâu sắc về Flutter mà còn truyền cảm hứng để Em vượt qua những khó khăn ban đầu.",
            ),
            _buildTextBlock(
              "Những kiến thức và kinh nghiệm thực tiễn Thầy truyền đạt sẽ là hành trang vô giá cho sự nghiệp phát triển phần mềm sau này của chúng em. Kính chúc Thầy thật nhiều sức khỏe và thành công trên con đường sự nghiệp trồng người!",
            ),
            const SizedBox(height: 30),
            
            // --- KÝ TÊN ---
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Trân trọng,", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
                  Text("Nhóm Lập trình Di động - Nhóm 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // --- CHÚ THÍCH ĐIỀU HƯỚNG ---
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Tiêu đề Mục
  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Khối Văn bản
  Widget _buildTextBlock(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey.shade800),
      ),
    );
  }
  
  // Helper Widget: Gạch đầu dòng
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16, color: Colors.redAccent)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, height: 1.4, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}