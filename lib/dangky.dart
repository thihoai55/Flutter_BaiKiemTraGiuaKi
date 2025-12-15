import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  _DangKyState createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();
  final TextEditingController _xacNhanController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final Color primaryColor = Colors.lightBlue.shade700;
  final Color secondaryColor = Colors.blue.shade100;

  @override
  void dispose() {
    _hoTenController.dispose();
    _emailController.dispose();
    _matKhauController.dispose();
    _xacNhanController.dispose();
    super.dispose();
  }
  
  // HÀM XỬ LÝ ĐĂNG KÝ
  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Lưu thông tin đăng ký (cục bộ)
      await prefs.setString('registered_email', _emailController.text.trim());
      await prefs.setString('registered_password', _matKhauController.text);
      await prefs.setString('registered_full_name', _hoTenController.text.trim()); // LƯU TÊN ĐẦY ĐỦ
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
          backgroundColor: Colors.green,
        ),
      );

      // Chuyển hướng về màn hình đăng nhập
      Navigator.pop(context); 
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: Header(),
      body: myBody(),
    );
  }

  AppBar Header() {
    return AppBar(
      title: const Text(
        'Tạo Tài Khoản Mới',
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

  Widget myBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30), 
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.person_add_alt_1,
              size: 80,
              color: primaryColor,
            ),
            const SizedBox(height: 30),

            // Họ tên
            TextFormField(
              controller: _hoTenController,
              decoration: _inputDecoration('Họ tên', Icons.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Mật khẩu
            TextFormField(
              controller: _matKhauController,
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
                  return 'Vui lòng nhập mật khẩu';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải ít nhất 6 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Xác nhận mật khẩu
            TextFormField(
              controller: _xacNhanController,
              obscureText: !_showConfirmPassword,
              decoration: _passwordInputDecoration(
                'Xác nhận mật khẩu', 
                Icons.lock_reset, 
                _showConfirmPassword, 
                () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (value != _matKhauController.text) {
                  return 'Mật khẩu không khớp';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Nút đăng ký
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add, color: Colors.white, size: 24),
                label: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 18
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: register, 
              ),
            )
          ],
        ),
      ),
    );
  }

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