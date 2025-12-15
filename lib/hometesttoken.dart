import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hometesttoken extends StatefulWidget {
  const Hometesttoken({super.key});

  @override
  State<Hometesttoken> createState() => _HometesttokenState();
}

class _HometesttokenState extends State<Hometesttoken> {
  String? token = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      isLoading = false;
    });
  }

  // Hàm xử lý Đăng xuất
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    // >>> ĐÃ SỬA LỖI NAVIGATOR: Chuyển hướng an toàn về màn hình đăng nhập <<<
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/dangnhap', // Chuyển về màn hình đăng nhập
      (Route<dynamic> route) => false, // Xóa tất cả các route cũ khỏi stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8), // Nền màu sáng nhẹ
      appBar: AppBar(
        title: const Text(
          "Trạng thái xác thực (Token)",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Thông tin Token đã lưu trong thiết bị:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // CARD HIỂN THỊ TOKEN CHÍNH
                  _buildTokenCard(context),

                  const SizedBox(height: 30),

                  // NÚT ĐĂNG XUẤT
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Đăng xuất",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTokenCard(BuildContext context) {
    bool hasToken = token != null && token!.isNotEmpty;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasToken ? Icons.check_circle_outline : Icons.error_outline,
                  color: hasToken ? Colors.green : Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  hasToken ? "Trạng thái: Đã đăng nhập" : "Trạng thái: Chưa đăng nhập",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: hasToken ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            const Text(
              "Giá trị Token:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            // HIỂN THỊ TOKEN
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText( // Dùng SelectableText để có thể copy Token
                hasToken ? token! : "Không tìm thấy Token trong SharedPreferences.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace', // Dùng font monospace cho dễ đọc chuỗi dài
                  color: hasToken ? Colors.black87 : Colors.black54,
                  fontWeight: hasToken ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (hasToken)
              const Text(
                "Lưu ý: Đây là JWT Token dùng để xác thực các request API tiếp theo (vd: /auth/me).",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
          ],
        ),
      ),
    );
  }
}