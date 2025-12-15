import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class Buoi4 extends StatefulWidget {
  const Buoi4({super.key});

  @override
  State<Buoi4> createState() => _Buoi4State();
}

class _Buoi4State extends State<Buoi4> {
  Color mauHienTai = Colors.purple.shade600; // Dùng shade để màu sâu hơn
  String tenMau = "Tím";

  // Danh sách màu được sắp xếp hợp lý và có màu sắc rõ ràng hơn
  final List<Map<String, dynamic>> danhSachMau = [
    {"ten": "Đỏ", "mau": Colors.red.shade600},
    {"ten": "Xanh lam", "mau": Colors.blue.shade600},
    {"ten": "Vàng", "mau": Colors.amber.shade600},
    {"ten": "Cam", "mau": Colors.orange.shade600},
    {"ten": "Lục", "mau": Colors.green.shade600},
    {"ten": "Hồng", "mau": Colors.pink.shade400},
    {"ten": "Xanh lơ", "mau": Colors.cyan.shade500},
    {"ten": "Nâu", "mau": Colors.brown.shade500},
  ];

  // Màu mặc định
  static final Color defaultColor = Colors.purple.shade600;
  static const String defaultColorName = "Tím";

  void doiMau() {
    // Chỉ trộn các màu trong danh sách để chọn ngẫu nhiên
    final randomMau = (danhSachMau..shuffle()).first;
    setState(() {
      mauHienTai = randomMau["mau"];
      tenMau = randomMau["ten"];
    });
  }

  void datLai() {
    setState(() {
      mauHienTai = defaultColor;
      tenMau = defaultColorName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Màu nền sẽ là màu hiện tại, nhưng nhẹ nhàng hơn nhiều
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: mauHienTai.withOpacity(0.1),
      appBar: header(),
      body: myBody(),
    );
  }

  // Header động theo màu nền
  AppBar header() {
    // Tính toán màu foreground (chữ và icon) dựa trên màu nền để đảm bảo dễ đọc
    final Color foregroundColor = mauHienTai.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return AppBar(
      backgroundColor: mauHienTai, // Màu AppBar thay đổi theo màu hiện tại
      foregroundColor: foregroundColor,
      elevation: 4, // Thêm độ nổi bật
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.colorize, size: 28), // Đổi icon chuyên nghiệp hơn
          SizedBox(width: 10),
          Text(
            "Color Changer",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: datLai,
          icon: const Icon(Icons.refresh),
          tooltip: "Đặt lại màu",
        ),
      ],
    );
  }

  // Phần thân chính
  Widget myBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Ô màu hiện tại (Đồ họa lớn)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: mauHienTai,
                borderRadius: BorderRadius.circular(20), // Bo góc lớn
                boxShadow: [
                  BoxShadow(
                    color: mauHienTai.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: Colors.white, width: 6), // Viền trắng nổi bật
              ),
              child: Center(
                child: Icon(
                  Icons.palette,
                  size: 50,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. Tên màu
            const Text(
              "Màu hiện tại:",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tenMau.toUpperCase(), // Viết hoa tên màu
              style: TextStyle(
                fontSize: 48, // Tăng kích thước
                fontWeight: FontWeight.w900,
                color: mauHienTai,
              ),
            ),
            
            const SizedBox(height: 60),

            // 3. Nút hành động
            SizedBox(
              width: 250, // Cố định chiều rộng cho nút
              child: ElevatedButton.icon(
                onPressed: doiMau,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mauHienTai, // Màu nút là màu hiện tại
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bo tròn viên thuốc
                  ),
                  elevation: 8,
                ),
                icon: const Icon(Icons.shuffle, color: Colors.white),
                label: const Text(
                  "ĐỔI MÀU NGẪU NHIÊN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            
            // Nút đặt lại (OutlinedButton)
            OutlinedButton.icon(
              onPressed: datLai,
              icon: const Icon(Icons.history, color: Colors.black54),
              label: const Text(
                "ĐẶT LẠI MÀU GỐC",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                side: const BorderSide(color: Colors.black26, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}