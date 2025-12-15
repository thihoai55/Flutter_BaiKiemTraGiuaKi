import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class BoDemTime extends StatefulWidget {
  const BoDemTime({super.key});

  @override
  State<BoDemTime> createState() => _BoDemTimeState();
}

class _BoDemTimeState extends State<BoDemTime> {
  TextEditingController controller = TextEditingController();
  int tongGiay = 0; // Tổng số giây còn lại
  int giayBanDau = 0; // Tổng số giây ban đầu (để tính tiến trình)
  int phut = 0;
  int giay = 0;
  Timer? timer;
  
  // Màu chủ đạo
  final Color primaryColor = Colors.blue.shade700;
  final Color startColor = Colors.green.shade600;
  final Color resetColor = Colors.red.shade600;

  void batDau() {
    int? giayNhap = int.tryParse(controller.text);
    if (giayNhap == null || giayNhap <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập số giây hợp lệ!")),
      );
      return;
    }
    
    // Nếu timer đang chạy và không phải là nút Tạm dừng/Tiếp tục (không cần trong logic hiện tại, nhưng là best practice)
    if (timer != null && timer!.isActive) {
      // Logic tạm dừng có thể được thêm vào đây
    }

    timer?.cancel(); // hủy timer cũ nếu còn chạy

    setState(() {
      tongGiay = giayNhap;
      giayBanDau = giayNhap; // Lưu lại giá trị ban đầu
      phut = tongGiay ~/ 60;
      giay = tongGiay % 60;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (tongGiay > 0) {
        setState(() {
          tongGiay--;
          phut = tongGiay ~/ 60;
          giay = tongGiay % 60;
        });
      } else {
        t.cancel();
        // Hiển thị dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Đã hết giờ!", style: TextStyle(color: resetColor, fontWeight: FontWeight.bold)),
              content: Row(
                children: [
                  Icon(Icons.timer_off, color: resetColor),
                  const SizedBox(width: 10),
                  const Expanded(child: Text("Thời gian đếm ngược đã kết thúc.")),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void datLai() {
    timer?.cancel();
    setState(() {
      tongGiay = 0;
      giayBanDau = 0;
      phut = 0;
      giay = 0;
      controller.clear();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), 
      backgroundColor: Colors.white,
      appBar: header(), 
      body: myBody()
    );
  }

  AppBar header() {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text("Bộ Đếm Ngược", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget myBody() {
    String phutStr = phut.toString().padLeft(2, '0');
    String giayStr = giay.toString().padLeft(2, '0');
    
    // Tính toán giá trị tiến trình
    double progressValue = (giayBanDau > 0) ? tongGiay / giayBanDau : 1.0;
    
    // Hiển thị phút:giây nếu tổng giây >= 60, ngược lại chỉ hiển thị giây
    String timeDisplay = (giayBanDau >= 60) ? "$phutStr:$giayStr" : (tongGiay > 0 ? "$giayStr giây" : "00 giây");

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Nhập liệu
            Text(
              "Thời gian đếm (giây):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 3),
                ),
                hintText: "Nhập số giây",
              ),
            ),
            const SizedBox(height: 40),

            // 2. Khu vực hiển thị đồng hồ (Circular Progress)
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Vòng tròn tiến trình
                  CircularProgressIndicator(
                    value: progressValue, // Giá trị từ 0.0 đến 1.0
                    backgroundColor: primaryColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(tongGiay > 0 ? startColor : resetColor),
                    strokeWidth: 15, // Độ dày vòng tròn
                  ),
                  
                  // Text hiển thị ở giữa
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeDisplay,
                          style: TextStyle(
                            fontSize: tongGiay >= 60 ? 60 : 45, // Kích thước lớn
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
                        if (giayBanDau >= 60 && tongGiay > 0) 
                          const Text(
                            "Phút:Giây",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 50),

            // 3. Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: batDau,
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text("BẮT ĐẦU", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: startColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: datLai,
                    icon: const Icon(Icons.stop_rounded, size: 28),
                    label: const Text("ĐẶT LẠI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: resetColor,
                      side: BorderSide(color: resetColor, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}