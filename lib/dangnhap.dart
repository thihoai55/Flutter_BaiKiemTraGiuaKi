import 'dart:convert';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Khai báo màu sắc đồng bộ với DangKy.dart
  final Color primaryColor = Colors.lightBlue.shade700;
  final Color successColor = Colors.green.shade600;
  final Color errorColor = Colors.red.shade600;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // HÀM ĐĂNG NHẬP (GIỮ NGUYÊN LOGIC BẠN ĐÃ CUNG CẤP)
  Future<void> login() async {
    String username = _userController.text.trim();
    String password = _passController.text.trim();

    var url = Uri.parse("https://dummyjson.com/auth/login");

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "expiresInMins": 30,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // API trả về 'token'
        String token = data['token'] ?? data['accessToken'] ?? data['access'] ?? '';

        // LƯU TOKEN
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (token.isNotEmpty) {
          await prefs.setString("token", token);
          
          // Thêm thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng nhập API thành công!"), backgroundColor: successColor)
          );

          // Chuyển sang màn hình Home
          Navigator.pushReplacementNamed(context, '/userprofile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng nhập thất bại: Không nhận được token"), backgroundColor: errorColor)
          );
        }
      } else {
        // Sai tài khoản hoặc lỗi API
        String errorMessage = "Đăng nhập thất bại. Vui lòng kiểm tra tài khoản.";
        try {
          var errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: errorColor)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: ${e.toString()}"), backgroundColor: errorColor)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: header(),
      // Loại bỏ Padding không cần thiết
      body: myBody(), 
    );
  }

  // ------------------------------
  // 1. HÀM HEADER (Đã đồng bộ)
  // ------------------------------
  AppBar header() {
    return AppBar(
      title: const Text(
        'Form Đăng nhập',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 4,
    );
  }

  // ------------------------------
  // 2. HÀM BODY (Đã chỉnh sửa giao diện)
  // ------------------------------
  Widget myBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_open_rounded,
            size: 100,
            color: primaryColor,
          ),
          const SizedBox(height: 40),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // USERNAME
                TextFormField(
                  controller: _userController,
                  decoration: _inputDecoration(
                    'Tên người dùng', 
                    Icons.person,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập tên người dùng";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // PASSWORD
                TextFormField(
                  controller: _passController,
                  obscureText: !_showPassword,
                  decoration: _passwordInputDecoration(
                    'Mật khẩu', 
                    Icons.lock,
                    _showPassword,
                    () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải >= 6 ký tự";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 20),

                // Nút chuyển sang Đăng ký
                TextButton(
                  onPressed: () {
                    // Giữ nguyên logic này: Chuyển sang màn hình Đăng ký
                    Navigator.pushNamed(context, '/dangky'); 
                  },
                  child: Text(
                    "Chưa có tài khoản? Đăng ký ngay!",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET MỚI: Input Decoration Đồng bộ với DangKy
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      hintText: 'Nhập $label',
    );
  }
  
  // WIDGET MỚI: Password Decoration Đồng bộ với DangKy
  InputDecoration _passwordInputDecoration(
    String label, 
    IconData icon, 
    bool isVisible, 
    VoidCallback onPressed
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      hintText: 'Nhập $label',
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey[700],
        ),
        onPressed: onPressed,
      ),
    );
  }
}