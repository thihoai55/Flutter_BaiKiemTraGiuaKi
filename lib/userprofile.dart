import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class Userporfile extends StatefulWidget {
  const Userporfile({super.key});

  @override
  State<Userporfile> createState() => _UserporfileState();
}

class _UserporfileState extends State<Userporfile> {
  Map<String, dynamic>? userData;
  bool isLocalProfile = false; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData(); 
  }

  // HÀM TẢI THÔNG TIN CỤC BỘ (TỪ SHARED PREFERENCES)
  Future<void> loadLocalProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Lấy thông tin đã lưu trong quá trình đăng nhập cục bộ
    String? email = prefs.getString('user_email'); 
    String? fullName = prefs.getString('user_full_name'); // LẤY TÊN ĐẦY ĐỦ
    
    if (email != null && fullName != null) { 
      // Tách First Name và Last Name giả lập
      List<String> names = fullName.split(' ');
      String firstName = names.isNotEmpty ? names.first : "Người dùng";
      String lastName = names.length > 1 ? names.sublist(1).join(' ') : "Cục bộ";
      
      setState(() {
        userData = {
          "firstName": firstName, 
          "lastName": lastName, 
          "email": email,
          "username": email.split('@').first, 
          "image": "https://i.pravatar.cc/150?u=$email", 
          "id": 0, 
          "birthDate": "N/A (Cục bộ)",
          "gender": "N/A (Cục bộ)",
          "address": {
            "address": "Không có thông tin",
            "city": "Cục bộ",
          },
        };
        isLocalProfile = true;
        isLoading = false;
      });
      return;
    }
    
    setState(() {
      isLoading = false;
      userData = null;
    });
  }

  // HÀM TẢI DỮ LIỆU KẾT HỢP (Ưu tiên API, sau đó là Cục bộ)
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // 1. KIỂM TRA API TOKEN
    if (token != null) {
      var url = Uri.parse("https://dummyjson.com/auth/me");
      try {
        var response = await http.get(
          url,
          headers: {"Authorization": "Bearer $token"},
        );

        if (response.statusCode == 200) {
          setState(() {
            userData = jsonDecode(response.body);
            isLocalProfile = false;
            isLoading = false;
          });
          return; 
        } 
      } catch (e) {
        print("Lỗi kết nối API: $e");
      }
    }
    
    // 2. TẢI DỮ LIỆU CỤC BỘ NẾU API THẤT BẠI HOẶC KHÔNG CÓ TOKEN
    await loadLocalProfile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8), 
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent, 
        title: Text(
          isLocalProfile ? "Thông tin Người dùng Cục bộ" : "Thông tin Người dùng API", 
          style: const TextStyle(color: Colors.white)
        ),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Phiên hết hạn hoặc chưa đăng nhập.", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/dangnhap'); 
                        },
                        child: const Text('Đăng nhập lại'),
                      )
                    ],
                  ),
                )
              : buildProfile(),
    );
  }

  // WIDGET HIỂN THỊ THÔNG TIN PROFILE (Giữ nguyên giao diện đẹp)
  Widget buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER PROFILE (CARD NỔI BẬT)
          Card(
            elevation: 8, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade50,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(userData!["image"]), 
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "${userData!["firstName"]} ${userData!["lastName"]}", 
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData!["email"],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Username: ${userData!["username"]}",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // CARD THÔNG TIN CHI TIẾT
          const Text(
            "Chi tiết Người dùng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const Divider(thickness: 1, height: 10),
          
          buildInfoCard(Icons.badge, "User ID", userData!["id"].toString()),
          if (isLocalProfile) 
            buildInfoCard(Icons.info, "Loại tài khoản", "Đã đăng ký Cục bộ"),

          buildInfoCard(Icons.calendar_month, "Ngày sinh", userData!["birthDate"] ?? "Không có dữ liệu"),
          buildInfoCard(Icons.wc, "Giới tính", userData!["gender"] ?? "Không có dữ liệu"),
          
          buildInfoCard(
            Icons.location_on, 
            "Địa chỉ", 
            userData!["address"] != null 
              ? (userData!["address"]["address"] + ", " + userData!["address"]["city"]) 
              : "Không có dữ liệu"
          ),
          

          const SizedBox(height: 30),

          // Nút đăng xuất
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Đăng xuất",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("token");
              await prefs.remove("isLoggedIn"); 
              
              // Xóa cả thông tin cục bộ để đảm bảo người dùng phải đăng nhập lại
              await prefs.remove("user_email");
              await prefs.remove("user_full_name");
              
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dangnhap', 
                (Route<dynamic> route) => false,
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // WIDGET CARD THÔNG TIN (Giữ nguyên)
  Widget buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}