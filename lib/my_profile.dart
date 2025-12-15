import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String name = 'Nguyễn Thị Hoài';
  String email = 'nguyenthihoai552004@gmail.com';
  String phone = '0819 923 174';
  String bio = 'Lập trình viên Flutter, thích xây ứng dụng đẹp và gọn.';
  String avatar = 'asset/anhhoai.jpg';

  // --- THÔNG TIN MỚI VỀ HỌC VẤN ---
  String subject = 'Lập trình di động - Nhóm 4';
  String lecturer = 'Nguyễn Dũng';
  String major = 'Công nghệ thông tin';
  String university = 'Đại học Khoa học Đại học Huế';
  // --- KẾT THÚC THÔNG TIN MỚI ---

  // --- Logic Profile (Giữ nguyên) ---
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('my_name') ?? name;
      email = prefs.getString('my_email') ?? email;
      phone = prefs.getString('my_phone') ?? phone;
      bio = prefs.getString('my_bio') ?? bio;
      avatar = prefs.getString('my_avatar') ?? avatar;
      // Không cần load thông tin học vấn từ prefs nếu chúng là cố định
    });
  }

  Future<void> saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_name', name);
    await prefs.setString('my_email', email);
    await prefs.setString('my_phone', phone);
    await prefs.setString('my_bio', bio);
    await prefs.setString('my_avatar', avatar);
  }

  // WIDGET TEXT FIELD CHO DIALOG (Giữ nguyên)
  Widget _buildEditField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  void editProfile() async {
    final _name = TextEditingController(text: name);
    final _email = TextEditingController(text: email);
    final _phone = TextEditingController(text: phone);
    final _bio = TextEditingController(text: bio);
    // Không cho phép chỉnh sửa thông tin học vấn cố định trong dialog này

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Chỉnh sửa thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField(_name, 'Tên', Icons.person),
              _buildEditField(_email, 'Email', Icons.email),
              _buildEditField(_phone, 'Số điện thoại', Icons.phone),
              _buildEditField(_bio, 'Tiểu sử', Icons.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = _name.text;
                email = _email.text;
                phone = _phone.text;
                bio = _bio.text;
              });
              saveProfile();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
  // --- HẾT Logic Profile ---

  // WIDGET HIỂN THỊ THÔNG TIN DẠNG CARD (Đã cải tiến)
  // Đổi tên thành _buildDetailCard để phù hợp hơn với vai trò CV
  Widget _buildDetailCard(IconData icon, String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 24), // Sử dụng màu động
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
  
  // WIDGET TÓM TẮT THỐNG KÊ (Bị loại bỏ)
  // Widget _buildStatCard(String value, String label, IconData icon, Color color) { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8), // Nền màu sáng nhẹ
      appBar: AppBar(
        title: const Text('Hồ sơ Cá nhân (CV)', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <<< HEADER PROFILE (FLOATING CARD) >>>
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.15), 
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.indigo.shade100!, width: 0.5),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.indigo.shade400!, width: 2), 
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(avatar),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Tên
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  // Tiểu sử (Bio)
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.indigo.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // <<< KẾT THÚC HEADER PROFILE >>>

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 20),
                  
                  // THÔNG TIN LIÊN HỆ
                  const Text(
                    "1. Thông tin liên hệ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(height: 10, thickness: 1),

                  _buildDetailCard(Icons.phone, 'Số điện thoại', phone, Colors.green),
                  _buildDetailCard(Icons.email_outlined, 'Email', email, Colors.redAccent),
                  
                  const SizedBox(height: 30),
                  
                  // THÔNG TIN HỌC VẤN VÀ CÔNG VIỆC
                  const Text(
                    "2. Thông tin Học vấn & Dự án",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(height: 10, thickness: 1),
                  
                  _buildDetailCard(Icons.school, 'Trường học', university, Colors.blue),
                  _buildDetailCard(Icons.local_library, 'Chuyên ngành', major, Colors.orange),
                  _buildDetailCard(Icons.class_, 'Môn học/Dự án', subject, Colors.purple),
                  _buildDetailCard(Icons.person_pin, 'Giảng viên hướng dẫn', lecturer, Colors.indigo),


                  const SizedBox(height: 30),
                  
                  // NÚT CHỨC NĂNG
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: editProfile,
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('Chỉnh sửa (Liên hệ)', style: TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chia sẻ hồ sơ')));
                          },
                          icon: const Icon(Icons.share, color: Colors.indigo),
                          label: const Text('Chia sẻ CV', style: TextStyle(fontSize: 16, color: Colors.indigo)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Colors.indigo, width: 2),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}