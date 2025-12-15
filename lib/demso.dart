import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class Demso extends StatefulWidget {
  const Demso({super.key});

  @override
  State<Demso> createState() => _DemsoState();
}

class _DemsoState extends State<Demso> {
  int soHienTai = 7;
  Color mauSo = Colors.indigo; // Màu mặc định (Trung tính)
  
  // Màu chủ đạo & hành động
  final Color primaryColor = Colors.indigo.shade700;
  final Color increaseColor = Colors.greenAccent.shade700; // Xanh lá sáng
  final Color decreaseColor = Colors.pinkAccent.shade700; // Hồng sáng
  final Color resetColor = Colors.blueGrey.shade400;

  @override
  void initState() {
    super.initState();
    // Đặt màu số ban đầu là màu chủ đạo
    mauSo = primaryColor; 
  }

  void tang() {
    setState(() {
      soHienTai++;
      mauSo = increaseColor; // Màu xanh lá sáng khi tăng
    });
  }

  void giam() {
    setState(() {
      soHienTai--;
      mauSo = decreaseColor; // Màu hồng sáng khi giảm
    });
  }

  void datLai() {
    setState(() {
      soHienTai = 7;
      mauSo = primaryColor; // Đặt lại màu số về màu chủ đạo
    });
  }

  // Phương thức tạo bóng Glow (tạo hiệu ứng Neon)
  List<Shadow> _getTextShadows(Color color) {
    return [
      Shadow(
        blurRadius: 10.0,
        color: color.withOpacity(0.8),
        offset: const Offset(0, 0),
      ),
      Shadow(
        blurRadius: 20.0,
        color: color.withOpacity(0.4),
        offset: const Offset(0, 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), 
      backgroundColor: Colors.white,
      appBar: header(), 
      body: myBody(),
      // Thêm FloatingActionButton để tăng/giảm số
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút GIẢM (Sử dụng FAB)
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: giam,
              backgroundColor: decreaseColor,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.remove, size: 30),
            ),
            
            // Nút TĂNG (Sử dụng FAB)
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: tang,
              backgroundColor: increaseColor,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.add, size: 30),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút ĐẶT LẠI (Được di chuyển xuống Bottom Bar)
            SizedBox(
              height: 50,
              child: TextButton.icon(
                onPressed: datLai,
                icon: Icon(Icons.refresh, size: 24, color: resetColor),
                label: Text("ĐẶT LẠI (7)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: resetColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header cố định
  AppBar header() {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      title: const Text(
        "Ứng dụng Đếm số",
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }

  // Body: Hiển thị số đếm
  Widget myBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Giá trị hiện tại:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Số đếm lớn với hiệu ứng GLOW
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 140, // Kích thước cực lớn
                fontWeight: FontWeight.w900,
                color: mauSo, 
                shadows: _getTextShadows(mauSo), // Áp dụng hiệu ứng phát sáng
              ),
              child: Text(
                "$soHienTai",
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Chú thích trạng thái
            Text(
              soHienTai > 7 ? "ĐANG TĂNG" : (soHienTai < 7 ? "ĐANG GIẢM" : "TRẠNG THÁI MẶC ĐỊNH"),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mauSo.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}